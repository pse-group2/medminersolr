# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Fill in the terms from external json

json = File.read('icd_2012_ch_de.json')
terms = JSON.parse(json)

file = File.open('./solr/conf/synonyms.txt', 'w')

terms.each do |term|
  text = term['text']
  
  synonyms = term['synonyms']
  
  
  delim1 = ' => '
  delim2 = ','
  
  puts text
  unless TextProcessor.new(text).word_count != 1  then
    
    synonyms = synonyms.map { |syn| syn = TextProcessor.new(syn).word_count == 1 ? syn : nil }
    synonyms = synonyms.compact 
    
    line = text << delim1
    synonyms.each do |synonym|
      line = line  << synonym << delim2
    end
    line = line.chomp(delim2)
  
    unless synonyms.empty? then
      file.puts line
    end
    
  end  
  
  
  # synonyms.each do |synonym|
    # line = synonym << delim1
    # line = line << text << delim2
    # synonyms.each do |synonym1|
         # line = line << synonym1 << delim2
    # end
    # #unless synonyms.empty? then
    # #  file.puts line
    # #end
  # end
  # line = line.chomp(delim2)
# 


  #delim = ','
  #line = %Q(") << text << %Q(") << delim
  
  #synonyms.each do |synonym|
  #  line = line << %Q(") << synonym << %Q(") << delim
  #end
  
  #line = line.chomp(delim)
#   
  # unless synonyms.empty? then
    # file.puts line
  # end
end

file.close