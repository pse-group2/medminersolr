class ResultsList
  
  def initialize (pages_array)
    @pages = pages_array
  end
  
  def count
    @pages.count
  end
end