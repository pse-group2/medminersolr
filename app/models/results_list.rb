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
  
  def all
    @hits
  end
  
  def intersect(result_list)
    p_keys_us = @hits.map {|hit| hit.primary_key}
    p_keys = result_list.all.map {|hit| hit.primary_key}
    
    # printable = p_keys_us.map {|i| Page.where(:text_id => i).first.page_title}
    # puts 'us: '.concat printable.to_s
#     
    # printable = p_keys.map {|i| Page.where(:text_id => i).first.page_title}
    # puts 'them: '.concat printable.to_s
    
    intersect = p_keys_us & p_keys 
#     
    # printable = intersect.map {|i| Page.where(:text_id => i).first.page_title}
    # puts 'intersect: '.concat printable.to_s
    # puts intersect
    # puts 'BREAK'
    intersect_hits = Array.new
    
    intersect.each do |key|
      
      hit_index = @hits.index {|hit| hit.primary_key == key}
      hit_found = @hits[hit_index]
      # found = Page.where(:text_id => hit_f.primary_key).first.page_title
      # puts 'found #{found}'
      
      intersect_hits.push hit_found
    end
    
    ResultsList.new(intersect_hits)
  end
end