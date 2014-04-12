class TextMiningController < ApplicationController
  def search
    @text = params[:search_text]
    
    unless @text.blank? then
      engine = SearchEngine.new(@text)
      list = engine.search_results
      
      @results = Array.new
      unless list.blank? then
      list.all.each do |hit|
        key = hit.primary_key
        page = Page.where(:text_id => key).first
        @results.push page
      end
      end
    end

  end

  def results
  end
end
