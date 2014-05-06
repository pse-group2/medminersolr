# This class models a list containing the results of a search request.
class ResultsList
  
  #The keywords that have been used to create/merge this list
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
    @hits.first.score
  end
  
  def lowest_score
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
  def intersect(result_list)
    p_keys_us = @hits.map {|hit| hit.primary_key}
    p_keys = result_list.all.map {|hit| hit.primary_key}
    
    intersect = p_keys_us & p_keys 
    intersect_hits = Array.new
    
    intersect.each do |key|
      
      hit_index = @hits.index {|hit| hit.primary_key == key}
      hit_found = @hits[hit_index]
      
      intersect_hits.push hit_found
    end
    keywords = used_keywords.clone
    keywords = keywords.concat result_list.used_keywords
    ResultsList.new(intersect_hits, keywords.uniq)
  end
  
  # Creates a union of two result lists.
  def unite (result_list)
    
    hits = @hits | result_list.all
    keywords = used_keywords | result_list.used_keywords
    ResultsList.new(hits, keywords.uniq)
  end
end