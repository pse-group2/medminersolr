class TextMiningController < ApplicationController
  
  def search
    @text = params[:search_text]

    unless @text.blank? then
      engine = SearchEngine.new(@text)
      @results = engine.search_results
      @used_keywords = printable_used_keywords(engine.used_keywords)
    end
    
  end
  
  private
  
  def printable_used_keywords(keywords_array)
    comma = ', '
    string = ''
    keywords_array.each do |word|
      string << word << ', '
    end
    string = string.chomp(comma)
  end
   
end
