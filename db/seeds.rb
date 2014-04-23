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
  code = term['code']
  
  synonyms = term['synonyms']
  
  delim = ','
  line = ''
  synonyms.each do |synonym|
    line = line << synonym << delim
  end
  line = line.chomp(delim)
  file.puts line
end

file.close