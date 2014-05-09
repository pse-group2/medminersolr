# This is a helper class for merging multiple lists of search results.
class ListMerger
  
  INTERSECT_BOOST = 30
  REORDER_TRESHOLD = 0.01
  
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

    temp_merge = ResultsList.new([],[])

    if !@lists.empty?
      temp_merge = @lists.first

      @lists.each do |list|
        old_merge = temp_merge.clone
         puts "temp_merge loop begin: #{temp_merge.count}"
        puts "lists count: #{@lists.size}"
        clone = list.clone
         puts "loop list: #{clone.count}"
        clone.normalize
        temp_merge.normalize
        puts temp_merge.count
        common_articles = temp_merge.intersect clone
        
        if common_articles.count > 0
          temp_merge = reorder_by_average_scores(temp_merge, clone, common_articles)
          temp_merge.boost_all(INTERSECT_BOOST)
        end
        puts temp_merge.count
        temp = temp_merge.clone
        temp_merge = temp_merge.unite list
        temp_merge = temp_merge.unite old_merge
        # puts temp.all - temp_merge.all
        puts "after unite: #{temp_merge.count}"
        temp_merge.sort
        puts "temp_merge loop end: #{temp_merge.count}"
      end
    end
    
    temp_merge.normalize
    puts "before return: #{temp_merge.count}"
    temp_merge
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
     
      
      max = [score1, score2].max
      min = [score1, score2].min
      
      if (min / max) > REORDER_TRESHOLD
        new_score = Math.sqrt(score1 * score2)
        hit.score = new_score
      else
        hit.score = max / INTERSECT_BOOST
      end
      
    end
    
    merged_list.sort
    merged_list
  end

end