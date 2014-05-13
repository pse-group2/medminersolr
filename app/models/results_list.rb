# This class models a list containing the results of a search request.
# It contains search hits, which have scores. This list can be intersected
# and united with other ResultsLists. 
class ResultsList
  
  # The keywords that have been used to create/merge this list
  attr_reader :used_keywords
  
  # The search_hits is an array containing instances of SearchHit.
  def initialize (search_hits, keywords=Array.new)
    @hits = search_hits.compact
    @used_keywords = keywords
    search_hits.keywords = keywords
  end
  
  def count
    all.size
  end
  
  def highest_score
    sort
    all.first.score
  end
  
  def lowest_score
    sort
    all.last.score
  end
  
  def score_range
    highest_score - lowest_score
  end
  
  # Returns all the hits in this list
  def all
    @hits
  end
  
  # Sorts the list descending by scores
  def sort
    @hits = all.sort {|x,y| y.score <=> x.score }
  end
  
  # Multiplies all scores by the given factor.
  def boost_all(factor)
    all.each do |hit|
      hit.score *= factor
    end
  end
  
  # Intersects to lists in such a way that the new list contains only
  # the elements that are contained in both lists. The intersected list
  # gets the keywords of both lists.
  def intersect(results_list)
    intersection_hits = self.all & results_list.all
    keywords = used_keywords | results_list.used_keywords
    
    ResultsList.new(intersection_hits, keywords.uniq)
  end
  
  # Creates a union of two result lists. The returned list also contains
  # all the keywords from the two lists.
  def unite (results_list)
    union_hits = self.all | results_list.all
    keywords = used_keywords | results_list.used_keywords
    
    ResultsList.new(union_hits, keywords.uniq)
  end
  
  # Scales the lists such that the highest score is 1 and the 
  # lowest score is 0. The returned list will be sorted.
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