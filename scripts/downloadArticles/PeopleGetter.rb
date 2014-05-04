#PeopleGetter downloads a list of JSON files created with http://tools.wmflabs.org/catscan2/quick_intersection.php, extracts the ID and stores everything in a local JSON file "filename"

require 'json'
require 'open-uri'

class PeopleGetter
  
  def initialize(filename, sourceList)
    @filename = filename
    @sourceList = sourceList
  end
  
  def download()
    counter = 1
    result = []
    @sourceList.each do |source|
      content = open(source, :content_length_proc => lambda{|content_length|
             bytes_total = content_length},
           :progress_proc => lambda{|bytes_transferred|
             print "\rDownloading JSON file #{counter}... %0.2f MB downloaded" % (bytes_transferred.to_f/1024.to_f/1024.to_f)
           }).read

      print "\nParsing file #{counter}...\n"

      pages = JSON.parse(content)["pages"]

      c = 0
      pages.each do |entry|
        result << entry["page_id"]
        c+=1
        print "\rExtracting relevant data... #{c} of #{pages.count} entries extracted."
      end
    
    end

    print "\nWriting to file '#{@filename}'...\n"
    File.open(@filename,"a") do |f|
      f.write(result.to_json)
    end
    print "Done!\n"
       
  end
  
end