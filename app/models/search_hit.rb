# This class simply wraps the Hit class from sunspot and makes the score writeable.
# It is used to merge lists of search results
class SearchHit < Sunspot::Search::Hit
  attr_accessor :score
  attr_reader :primary_key
  
  def initialize(hit)
    @score = hit.score
    @primary_key = hit.primary_key
  end
  
end