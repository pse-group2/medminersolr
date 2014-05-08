# This class simply wraps the Hit class from sunspot and makes the score writeable.
# It is used to merge lists of search results
class SearchHit
  attr_accessor :score
  attr_accessor :contains_dimensionword
  attr_reader :primary_key
  
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
  
  def page
    Page.where(:text_id => primary_key).first
  end
end