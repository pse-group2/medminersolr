#JSONGetter lädt ein mit http://tools.wmflabs.org/catscan2/quick_intersection.php erzeugtes JSON file ("source") runter und extrahiert daraus page_id, page_title und page_latest in ein JSON file ("filename")

require 'json'
require 'open-uri'

class ArticleGetter
  
  def initialize(filename, source)
    @filename = filename
    @json_url = source
  end
  
  def download()
    #download the JSON file at the specified URL
    an_int = 1
    content = open(@json_url, :content_length_proc => lambda{|content_length|
           bytes_total = content_length},
         :progress_proc => lambda{|bytes_transferred|
           print "\rDownloading JSON file... %0.2f MB downloaded" % (bytes_transferred.to_f/1024.to_f/1024.to_f)
         }).read

    print "\nParsing...\n"

    #load into array
    pages = JSON.parse(content)["pages"]

    #extract relevant data - page ID, title and text ID, store into array
    result = []
    c = 0
    pages.each do |entry|
      newEntry = {}
      newEntry["page_id"] = entry["page_id"]
      newEntry["page_title"] = entry["page_title"]
      newEntry["text_id"] = entry["page_latest"]
      result << newEntry
      c+=1
      print "\rExtracting relevant data... #{c} of #{pages.count} entries extracted."
    end

    print "\nWriting to file '#{@filename}'...\n"
    #store extracted data in specified file
    File.open(@filename,"wb") do |f|
      f.write(result.to_json)
    end
    
    print "Done!\n"
    
  end
  
end