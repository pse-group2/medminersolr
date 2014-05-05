require 'net/http'
require 'uri'
require 'nokogiri'
require 'mysql2'

class Downloader

  #pct: percentage of articles that have been downloaded
  #c: number of articles that have been downloaded
  attr_accessor :pct
  attr_accessor :c
  attr_accessor :name
  
  #requires a mysql client, an array of hashes containing page ID, text ID and name of wikipedia articles, a name for the downloader
  def initialize(client, array, name)
    @client = client
    @input = array
    @c = 0
    @length = @input.length.to_i
    @pct = 0
    @name = name
  end

  def openURL(url)
    Net::HTTP.get(URI.parse(url))
  end
  

  def startDownload
    #iterate over array of articles
    @input.each do |name|
      #calculate percentage
      @pct = (@c.to_f/@length.to_f*100).round(3)
      #check if article already exists
      check = @client.query("SELECT * FROM page WHERE page_id = #{name["page_id"]}").count
      unless check == 1
        #get raw text contents of article
        url = "http://de.wikipedia.org/w/index.php?curid=#{name["page_id"]}"
        doc = Nokogiri::HTML(openURL(url))
        text = ''
        doc.css('p,h1').each do |e|
          text << e.content
        end
        #insert into database
        pquery = "INSERT INTO page (page_id, page_title, text_id) VALUES(#{name["page_id"]}, '#{name["page_title"].gsub("'", %q(\\\'))}', #{name["text_id"]})"
        tquery = "INSERT INTO text (page_id, content, text_id) VALUES(#{name["page_id"]}, '#{text.gsub("'", %q(\\\'))}', #{name["text_id"]})"
        @client.query(pquery)
        @client.query(tquery)
        @c+=1
      end
    end
  end
  
end

  