#Downloader downloads Wikipedia articles and stores them into a MYSQL database.

require 'net/http'
require 'uri'
require 'nokogiri'
require 'mysql2'

class Downloader

  attr_accessor :pct
  attr_accessor :c
  attr_accessor :name
  
  #requires a mysql client, an array of hashes containing page ID, text ID and name of Wikipedia articles, a name for the downloader
  #client: A mysql2 (ruby gem) client
  #array: Array of hashes containing page_id, text_id and page_title of Wikipedia articles
  #name: Name of the Downloader. Can be used for debugging.
  def initialize(client, array, name)
    @client = client
    @input = array
    @length = @input.length.to_i
    @c = 0
    @name = name
  end

  def openURL(url)
    Net::HTTP.get(URI.parse(url))
  end
  
  def startDownload
    @input.each do |name|
      while @client.query("SELECT * FROM page WHERE page_id = #{name["page_id"]}").first.nil? do
        
        begin 
          
          page_id = name["page_id"].to_i
          page_title = name["page_title"]
          text_id = name["text_id"].to_i
          if @client.query("SELECT * FROM page WHERE page_id = #{page_id}").count == 1
            if @client.query("SELECT text_id FROM page WHERE page_id = #{page_id}").each[0]["text_id"] != text_id
              @client.query("DELETE FROM page WHERE page_id=#{page_id}")
              @client.query("DELETE FROM text WHERE page_id=#{page_id}")
              downloadArticle(page_id, text_id, page_title)
            end
          else
            downloadArticle(page_id, text_id, page_title)
          end
        
        rescue SocketError
          puts "\nWikipedia blocked the request, retrying in 10 seconds."
          sleep(10)
        end
        
      end
      @c+=1
    end
  end
  
  def downloadArticle(page_id, text_id, page_title)
    url = "http://de.wikipedia.org/w/index.php?curid=#{page_id}"
    doc = Nokogiri::HTML(openURL(url))
    text = ''
    doc.css('p,h1').each do |e|
      text << e.content
    end
    @client.query("INSERT INTO page (page_id, page_title, text_id) VALUES(#{page_id}, '#{page_title.gsub("'", %q(\\\'))}', #{text_id})")
    @client.query("INSERT INTO text (page_id, content, text_id) VALUES(#{page_id}, '#{text.gsub("'", %q(\\\'))}', #{text_id})")
  end
  
end

  