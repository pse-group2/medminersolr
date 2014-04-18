# This class models a list containing the results of a search request.
class ResultsList
  
  def initialize (sunspot_hits)
    @hits = sunspot_hits.compact
    puts @hits
  end
  
  def count
    @hits.total
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
    
    ResultsList.new(intersect_hits)
  end
end