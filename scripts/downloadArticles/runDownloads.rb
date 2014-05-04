require './Downloader'
require './ArticleGetter'
require './PeopleGetter'
require 'json'
require 'open-uri'

#number of downloaders that will be run
threadNumber = 100;
#database stuff, filenames, addresses
username = "root"
password = "toor"
dbname = "medwikisolr"
articles_filename = 'articles.json'
people_filename = 'people_list.json'
#JSON - source of all articles in the category "Medizin"
article_source = "http://tools.wmflabs.org/catscan2/quick_intersection.php?lang=de&project=wikipedia&cats=Medizin&ns=0&depth=-1&max=100000&start=0&format=json&redirects=&callback="
#JSON - intersection of "Medizin" and "Mann"
menURL = "http://tools.wmflabs.org/catscan2/quick_intersection.php?lang=de&project=wikipedia&cats=Medizin%0D%0AMann&ns=0&depth=12&max=30000&start=0&format=json&redirects=&callback="
#JSON - intersection of "Medizin" and "Frau"
womenURL = "http://tools.wmflabs.org/catscan2/quick_intersection.php?lang=de&project=wikipedia&cats=Medizin%0D%0AFrau&ns=0&depth=12&max=30000&start=0&format=json&redirects=&callback="

#DB layout:
#TABLE page, ROW page_id (int), ROW page_title (text), ROW text_id(int)
#TABLE text, ROW page_id (int), ROW content (medium_blob), ROW text_id(int)
@client = Mysql2::Client.new(:host => "localhost", :username => username, :password => password, :database => dbname)
#TODO: check if DB exists and if no, create one with the appropriate name

#create json file with articles about people (only IDs) if none exists
unless File.exists?(people_filename)
  print "Getting IDs of articles about people...\n"
  peopleGetter = PeopleGetter.new(people_filename, [menURL, womenURL])
  peopleGetter.download
end

#create json file with article data if none exists
unless File.exists?(articles_filename)
  print "Getting list of articles...\n"
  articleGetter = ArticleGetter.new(articles_filename, [article_source])
  articleGetter.download
end

#load article data into array
articles = JSON.parse(open(articles_filename).read)
#load IDs of articles about people into array
blacklist = JSON.parse(open(people_filename).read)
totalLength = articles.length

#create downloaders, store in array - the array is split evenly among the downloaders, every downloader receives a subarray
downloaders = []
i = 0
while i < threadNumber
  client = Mysql2::Client.new(:host => "localhost", :username => username, :password => password, :database => dbname)
  downloaders << Downloader.new(client, articles[(totalLength/threadNumber)*i+i..(totalLength/threadNumber)*(i+1)+i], "Downloader#{i+1}", blacklist)
  i+=1
end

start = Time.now

#create a thread for every downloader. run downloaders parallely.
threads = []
downloaders.each do |d|
    threads << Thread.new{d.startDownload}
end
print "Running #{downloaders.count} downloaders on #{totalLength.to_i} entries...\n"
pct = 0
#loop for displaying the downloader's progress 
while pct < 100
  sum = 0
  downloaders.each do |d|
    sum += d.c
  end
  pct = (sum.to_f/totalLength.to_f*100).round(3)
  print "\rDownloading: #{sum} of #{totalLength} articles\t#{pct}%"
  sleep 1
end

#time stats
finish = Time.now
t = finish-start
mm, ss = t.divmod(60)          
hh, mm = mm.divmod(60)          
print "\nDone! Downloaded #{sum} of #{totalLength}. #{blacklist.length} articles were blacklisted. Time elapsed: %d hours, %d minutes and %d seconds\n" % [hh, mm, ss]