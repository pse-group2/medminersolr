class ResultsList
  
  def initialize (sunspot_hits)
    @hits = sunspot_hits
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
  
  def all
    @hits
  end
  
  def intersect(result_list)
    p_keys_us = @hits.map {|hit| hit.primary_key}
    p_keys = result_list.all.map {|hit| hit.primary_key}
    
    intersect = p_keys_us & p_keys 
    
    intersect_hits = Array.new
    
    intersect.each do |key|
       intersect_hits.push @hits.bsearch {|hit| hit.primary_key == key}
    end
    
    ResultsList.new(intersect_hits)
  end
end