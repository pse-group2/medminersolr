# This is a helper class for merging multiple lists of search results.
class ListMerger
  def initialize
    @lists = Array.new
  end

  def push (results_list)
    @lists.push results_list
  end

  def clear
    @lists.clear
  end

  #returns nil if there are no lists to merge
  def merge

    temp_intersection = ResultsList.new([],[])

    if !@lists.empty?
      temp_intersection = @lists.first

      @lists.each do |list|
        common_articles = temp_intersection.intersect list
        puts common_articles.count
        if common_articles.count > 0
          temp_intersection = reorder_by_average_scores(temp_intersection, list, common_articles)
        end
      end
    end

    temp_intersection
  end

  private

  def reorder_by_average_index(list1, list2, intersection)

    reordered = Array.new(intersection.count)

    intersection.all.each do |hit|
      index1 = list1.all.index {|h| h.primary_key == hit.primary_key}
      index2 = list2.all.index {|h| h.primary_key == hit.primary_key}

      new_index = (index1 + index2) / 2
      new_index = new_index.round
     
      reordered.insert(new_index, hit)
    end
    ResultsList.new(reordered, intersection.used_keywords)
  end
  
  def reorder_by_average_scores(list1, list2, merged_list)

    merged_list.all.each do |hit|
      index1 = list1.all.index {|h| h.primary_key == hit.primary_key}
      index2 = list2.all.index {|h| h.primary_key == hit.primary_key}

      score1 = list1.all[index1].score
      score2 = list2.all[index2].score
     
      new_score = (score1 + score2) / 2
      hit.score = new_score
    end
    
    merged_list.sort
    merged_list
  end

end