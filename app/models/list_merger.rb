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
        if common_articles.count > 0
          temp_intersection = reorder(temp_intersection, list, common_articles)
        else 
        end
      end
    end
    
    temp_intersection
  end
  
  private 
  
  def reorder(list1, list2, intersection)
    
    reordered = Array.new(intersection.count  )
    
    intersection.all.each do |hit|
      index1 = list1.all.index {|h| h.primary_key == hit.primary_key}
      index2 = list2.all.index {|h| h.primary_key == hit.primary_key}
      
      new_index = (index1 + index2) / 2
      new_index = new_index.round
      
      reordered[new_index] = hit
    end
     
     ResultsList.new(reordered, intersection.used_keywords)
  end
  
end