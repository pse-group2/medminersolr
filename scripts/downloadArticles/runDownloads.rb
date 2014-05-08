require './Downloader'
require './Remover'
require './ArticleGetter'
require './PeopleGetter'
require 'json'
require 'open-uri'
require 'ruby-progressbar'

#number of downloaders that will be run
threadNumber = 100;
removerC = 20
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
peopleCount = blacklist.count
totalLength = articles.length

#create downloaders, store in array - the array is split evenly among the downloaders, every downloader receives a subarray
downloaders = []
i = 0
while i < threadNumber
  client = Mysql2::Client.new(:host => "localhost", :username => username, :password => password, :database => dbname)
  downloaders << Downloader.new(client, articles[(totalLength/threadNumber)*i+i..(totalLength/threadNumber)*(i+1)+i], "Downloader#{i+1}")
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

print "\nRemoving articles about people...\n"
removers = []
i = 0
while i < removerC
  client = Mysql2::Client.new(:host => "localhost", :username => username, :password => password, :database => dbname)
  removers << Remover.new(client, blacklist[(peopleCount/removerC)*i+i..(peopleCount/removerC)*(i+1)+i])
  i+=1
end

threads = []
removers.each do |r|
    threads << Thread.new{r.start}
end

print "Running #{removers.count} removers on #{peopleCount.to_i} entries...\n"
pBar = ProgressBar.create(:title => " Removing people: ", :total => peopleCount, :format => '%t %p%% |%B| %a')
sum = 0
while sum < peopleCount
  sum = 0
  removers.each do |d|
    sum += d.c
  end
  pBar.progress=sum
  sleep 1
end

#time stats
finish = Time.now
t = finish-start
mm, ss = t.divmod(60)          
hh, mm = mm.divmod(60)          
print "\nDone! Downloaded #{totalDownloaded} of #{totalLength}. #{peopleCount} articles were blacklisted. Time elapsed: %d hours, %d minutes and %d seconds\n" % [hh, mm, ss]