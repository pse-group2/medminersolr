class ResultsList
  
  def initialize (sunspot_result)
    @search = sunspot_result
  end
  
  def count
    @pages.count
  end
  
  def highest_score
    @search.hits.first.score
  end
  
  def lowest_score
    @search.hits.last.score
  end
  
  def score_range
    highest_score - lowest_score
  end
  
  def average_score
    score_range / count
  end
  
  def all
    @search.results
  end
end