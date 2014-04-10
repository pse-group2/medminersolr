class TextMiningController < ApplicationController
  def search
    @text = params[:search_text]
    
    unless @text.blank? then
      engine = SearchEngine.new(@text)
      @results = engine.search_results.first
    end

  end

  def results
  end
end
