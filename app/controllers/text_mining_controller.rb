class TextMiningController < ApplicationController
  
  @wikipedia_invisible = true
  
  def search
    @text = params[:search_text]

    unless @text.blank? then
      @wikipedia_invisible = false
      engine = SearchEngine.new(@text)
      @results = engine.search_results
      @used_keywords = printable_words_array(engine.used_keywords)
      @dimensionwords = printable_words_array(engine.dimensionwords)
    end
    
  end
  
  private
  
  def printable_words_array(keywords_array)
    comma = ', '
    string = ''
    keywords_array.each do |word|
      string << word << ', '
    end
    string = string.chomp(comma)
  end
   
end
