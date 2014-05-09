# This is a helper class for merging multiple lists of search results.
class ListMerger
  
  # This boost will be applied to search results if they
  # occur in multiple lists
  INTERSECTION_BOOST = 30
  # This percentage threshold is used to determine whether the 
  # new score in the merged list should be the average or not.
  # If the score gap between the results is too high, the 
  # lower score is considered a 'error' and the higher score 
  # gets chosen.
  REORDER_TRESHOLD = 0.1
  
  def initialize
    @lists = Array.new
  end

  def push (results_list)
    @lists.push results_list
  end

  def clear
    @lists.clear
  end

  # Merges all the lists pushed to this ListMerger together into one
  # single list. This is done by repeatedly merging two successive lists together.
  # Elements that occur in multiple lists will be boosted. The order in 
  # which the lists are merged does not matter.
  # Returns nil if there are no lists to merge.
  def merge

    temp_merge = ResultsList.new([],[])

    if !@lists.empty?
      temp_merge = @lists.first

      @lists.each do |list|
        old_merge = temp_merge.clone
        
        list.normalize
        temp_merge.normalize
        
        common_articles = temp_merge.intersect list
        
        if common_articles.count > 0
          temp_merge = reorder_by_average_scores(temp_merge, list, common_articles)
          temp_merge.boost_all(INTERSECTION_BOOST)
        end
        
        temp_merge = temp_merge.unite list
        temp_merge = temp_merge.unite old_merge
        temp_merge.sort
      end
    end
    
    temp_merge.normalize
    temp_merge
  end

  private

  # Reorders a list merged from two other lists. The new score in the
  # merged_list is the geometric mean of the scores in the original lists.
  # In a special case where the relative gap between two scores is higher than
  # a given threshold, the higher one will be picked as the new score.
  # The returned list is sorted by the new scores.
  def reorder_by_average_scores(list1, list2, merged_list)

    merged_list.all.each do |hit|
      index1 = list1.all.index {|h| h == hit}
      index2 = list2.all.index {|h| h == hit}

      score1 = list1.all[index1].score
      score2 = list2.all[index2].score
     
      max = [score1, score2].max
      min = [score1, score2].min
      
      if (min / max) > REORDER_TRESHOLD
        new_score = Math.sqrt(score1 * score2)
        hit.score = new_score
      else
        hit.score = max / INTERSECTION_BOOST
      end
      
    end
    
    merged_list.sort
    merged_list
  end

end