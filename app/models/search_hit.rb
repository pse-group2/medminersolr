# This class simply wraps the Hit class from Sunspot to make the score writable.
# It is used to merge lists of search results. 
class SearchHit
  
  attr_accessor :score
  # Can be set from outside to mark if the article of this
  # SearchHit contains a dimension word
  attr_accessor :contains_dimensionword
  attr_reader :primary_key
  
  # Requires a Sunspot::Search::Hit
  def initialize(hit)
    @score = hit.score
    @primary_key = hit.primary_key
    @contains_dimensionword = false
  end
  
  def ==(other)
    @primary_key == other.primary_key
  end
  
  def eql?(other)
    self == other
  end
  
  def hash
    primary_key.hash
  end
  
  # Returns the page associated with this SearchHit.
  def page
    Page.where(:text_id => primary_key).first
  end
  
  def text
    Text.where(:text_id => primary_key).first
  end
  
  def surrounding_text
    text = text.content
    p = TextProcessor.new(text)
  end
end