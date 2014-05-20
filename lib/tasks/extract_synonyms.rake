require 'json'

task :extract_synonyms => :environment do
  extract(Rails.root + 'lib/resources/icd_2012_ch_de.json', Rails.root + 'solr/conf/synonyms.txt')
end

DELIM = ','

def extract(from_json, to_file)

  json = File.read(from_json)
  terms = JSON.parse(json)
  
  file = File.open(to_file, 'w')

  terms.each do |term|
    text = term['text']
    synonyms = term['synonyms']
    synonyms.push text
    
    synonyms = terms_with_word_count_one(synonyms)
    synonyms.uniq!
    synonyms_to_file(synonyms, file)
  end

  file.close
end

def synonyms_to_file(synonyms, file)
  line = synonyms_to_string(synonyms)
  word_count = TextProcessor.new(line).word_count
  
  unless line.empty? or word_count == 1 then
    file.puts line
  end
end

def terms_with_word_count_one(term_array)
  term_array.map! { |term| term = TextProcessor.new(term).word_count == 1 ? term : nil}
  term_array.compact!
  term_array
end

def synonyms_to_string(synonyms_array)
  string = ''
  synonyms_array.each do |syn|
    string = string << syn << DELIM
  end
  string = string.chomp(DELIM)
end