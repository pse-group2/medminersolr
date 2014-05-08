# This class models a list containing the results of a search request.
class ResultsList
  
  # The keywords that have been used to create/merge this list
  @used_keywords = Array.new
  attr_reader :used_keywords
  
  def initialize (sunspot_hits, keywords)
    @hits = sunspot_hits.compact
    @used_keywords = keywords
  end
  
  def count
    @hits.size
  end
  
  def highest_score
    sort
    @hits.first.score
  end
  
  def lowest_score
    sort
    @hits.last.score
  end
  
  def score_range
    highest_score - lowest_score
  end
  
  def average_score
    score_range / count
  end
  
  # Returns all the hits in this list
  def all
    @hits
  end
  
  # Sorts the list descending by scores
  def sort
    @hits = @hits.sort {|x,y| y.score <=> x.score }
  end
  
  # Multiplies all scores by the given factor.
  def boost_all(factor)
    @hits.each do |hit|
      hit.score *= factor
    end
  end
  
  # Intersects to lists in such a way that the new list contains only
  # the elements that are contained in both lists
  def intersect(results_list)
    intersection_hits = @hits & results_list.all
    
    keywords = used_keywords.clone
    keywords = keywords.concat results_list.used_keywords
    ResultsList.new(intersection_hits, keywords.uniq)
  end
  
  # Creates a union of two result lists.
  def unite (results_list)
    union_hits = @hits | results_list.all
    keywords = used_keywords | results_list.used_keywords
    ResultsList.new(union_hits, keywords.uniq)
  end
  
  def normalize
    unless @hits.empty? then 
      max = highest_score
      min = lowest_score
      all.each do |hit| 
        hit.score = (hit.score - min)/(max - min)
      end
      sort
    end
  end
end