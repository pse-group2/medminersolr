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
  
  def merge

    temp_intersection = @lists.first
    
    unless @lists.count == 1 then
      
      @lists.each do |list|
        temp_intersection = temp_intersection.intersect list
      end
    end
    
    temp_intersection
  end
end