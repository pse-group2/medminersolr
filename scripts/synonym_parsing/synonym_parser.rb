require 'json'
require './app/models/text_processor'

class SynonymParser

  ARROW = ' => '
  DELIM = ','
  
  def self.parse

    json = File.read('icd_2012_ch_de.json')
    terms = JSON.parse(json)

    file = File.open('./solr/conf/synonyms.txt', 'w')

    terms.each do |term|
      text = term['text']
      synonyms = term['synonyms']
      synonyms.push text
      
      synonyms = terms_with_word_count_one(synonyms)
      synonyms.uniq!
      # all_arrow_combinations(synonyms, file)
      all_combinations_without_arrows(synonyms, file)
    end

    file.close
  end

  private
  
  def self.all_combinations_without_arrows(synonyms, file)
    line = synonyms_to_string(synonyms)
    word_count = TextProcessor.new(line).word_count
    
    unless line.empty? or word_count == 1 then
      file.puts line
    end
  end
  
  def self.all_arrow_combinations(synonyms, file)
    synonyms.each do |syn|
      line = ''
      line = line << syn.downcase << ARROW << synonyms_to_string(synonyms)
      file.puts line
    end
  end
  
  def self.terms_with_word_count_one(term_array)
    term_array = term_array.map { |term| term = TextProcessor.new(term).word_count == 1 ? term : nil}
    term_array = term_array.compact
    term_array
  end
  
  def self.synonyms_to_string(synonyms_array)
    string = ''
    synonyms_array.each do |syn|
      string = string << syn << DELIM
    end
    string = string.chomp(DELIM)
  end

end

SynonymParser.parse