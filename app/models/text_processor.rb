require 'treat'
require 'stanford-core-nlp'

include Treat::Core::DSL
Treat.core.language.default = 'german'

# This helper class provides basic methods to process text chunks
class TextProcessor
  
  def initialize(text)
    @text = text.to_entity
    @text.apply(:chunk, :segment, :tokenize)
  end

  def frequency_of(word)
    @text.frequency_of(word)
  end

  def word_count
    @text.word_count
  end

  # Returns an array of all the words occurring in the text.
  def words
    @text.words.map {|word| word.to_s}.uniq
  end

  # Returns an array of all the nouns occurring in the text.
  def nouns
    nouns = Array.new
    words.each do |word|
      if self.class.is_noun(word)
      nouns.push word
      end
    end
    nouns
  end

  def adjectives
    adjectives = Array.new
    words.each do |word|
      if self.class.is_adjective(word)
      adjectives.push word
      end
    end
    adjectives
  end

  def keywords
    nouns.concat adjectives
  end

  def self.is_noun(word)
    if word.category == 'noun'
    result = true
    else
    result = false
    end
    result
  end

  def self.is_adjective(word)
    if word.category == 'ajective'
    result = true
    else
    result = false
    end
    result
  end

  def parse_tree
    @text.do(:parse)
  end
end