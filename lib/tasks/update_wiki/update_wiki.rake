require 'json'
require 'open-uri'
require 'ruby-progressbar'
require_relative 'Downloader'
require_relative 'Remover'
require_relative 'ArticleGetter'
require_relative 'PeopleGetter'


ARTICLES_FILENAME = Rails.root + 'tmp/articles.json'
PEOPLE_FILENAME =  Rails.root + 'tmp/people_list.json'
#JSON - intersection of "Medizin" and "Mann"
MEN_URL = "http://tools.wmflabs.org/catscan2/quick_intersection.php?lang=de&project=wikipedia&cats=Medizin%0D%0AMann&ns=0&depth=12&max=30000&start=0&format=json&redirects=&callback="
#JSON - intersection of "Medizin" and "Frau"
WOMEN_URL = "http://tools.wmflabs.org/catscan2/quick_intersection.php?lang=de&project=wikipedia&cats=Medizin%0D%0AFrau&ns=0&depth=12&max=30000&start=0&format=json&redirects=&callback=" 
#JSON - source of all articles in the category "Medizin"
ARTICLE_SOURCE = "http://tools.wmflabs.org/catscan2/quick_intersection.php?lang=de&project=wikipedia&cats=Medizin&ns=0&depth=-1&max=100000&start=0&format=json&redirects=&callback="
# Number of downloaders that will be run.
THREAD_NUMBER = 100;    

namespace :wiki do  
  
  desc "Downloads all pages from the german wikipedia"
  task :download  => :environment do
    
    start = Time.now
    #load article data into array
    articles = download_article_data
    totalLength = articles.length
    
    #create downloaders, store in array - the array is split evenly among the downloaders, every downloader receives a subarray
    downloaders = []
    i = 0
    while i < THREAD_NUMBER
      client = connect_to_database
      downloaders << Downloader.new(client, articles[(totalLength/THREAD_NUMBER)*i+i..(totalLength/THREAD_NUMBER)*(i+1)+i], "Downloader#{i+1}")
      i+=1
    end
    
    #create a thread for every downloader. run downloaders parallely.
    threads = []
    downloaders.each do |d|
        threads << Thread.new{d.startDownload}
    end
    print "Running #{downloaders.count} downloaders on #{totalLength.to_i} entries...\n"
    pct = 0
    #loop for displaying the downloader's progress 
    pBar = ProgressBar.create(:title => " Downloading articles: ", :total => totalLength, :format => '%t %p%% |%B| %a')
    sum = 0
    while sum < totalLength
      sum = 0
      downloaders.each do |d|
        sum += d.c
      end
      pBar.progress=sum
      sleep 1
    end
    totalDownloaded = sum
    pBar.finish
    
    
    #time stats
    finish = Time.now
    t = finish-start
    mm, ss = t.divmod(60)          
    hh, mm = mm.divmod(60)          
    print "\nDone! Downloaded #{totalDownloaded} of #{totalLength}. Time elapsed: %d hours, %d minutes and %d seconds\n" % [hh, mm, ss]
  end
  
  desc "Removes pages about people in the database"
  task :remove_people  => :environment do
    
    client = connect_to_database
    
     #load IDs of articles about people into array
    blacklist = download_people_data
    peopleCount = blacklist.count
    
    print "\nRemoving articles about people...\n"
    deleteIDs = open(PEOPLE_FILENAME).read.gsub('","', ",\n").gsub('["', "(").gsub('"]', ")")
    client.query("DELETE FROM page WHERE page_id IN #{deleteIDs};")
    client.query("DELETE FROM text WHERE page_id IN #{deleteIDs};")
    
  end
  
  task :update => [:download, :remove_people]
  
  
  def connect_to_database
    config = Rails.configuration.database_configuration
    host = config[Rails.env]["host"]
    dbname = config[Rails.env]["database"]
    username = config[Rails.env]["username"]
    password = config[Rails.env]["password"]
    
    #TODO: check if DB exists and if no, create one with the appropriate name
    Mysql2::Client.new(:host => host, :username => username, :password => password, :database => dbname)
  end
  
  def download_article_data
    #create json file with article data if none exists
    unless File.exists?(ARTICLES_FILENAME)
      print "Getting list of articles...\n"
      articleGetter = ArticleGetter.new(ARTICLES_FILENAME, [ARTICLE_SOURCE])
      articleGetter.download
    end
    
    JSON.parse(open(ARTICLES_FILENAME).read)
  end
  
  def download_people_data
    #create json file with articles about people (only IDs) if none exists
    unless File.exists?(PEOPLE_FILENAME)
      print "Getting IDs of articles about people...\n"
      peopleGetter = PeopleGetter.new(PEOPLE_FILENAME, [MEN_URL, WOMEN_URL])
      peopleGetter.download
    end
    
    JSON.parse(open(PEOPLE_FILENAME).read)
  end
end