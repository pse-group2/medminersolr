class TextMiningController < ApplicationController
  
  def search
    @text = params[:search_text]

    unless @text.blank? then
      engine = SearchEngine.new(@text)
      list = engine.search_results
      @results = get_pages_from_hits(list)
      @used_keywords = engine.used_keywords
    end
    
  end

  private

  def get_pages_from_hits(list)
    results = Array.new

    unless list.blank? then
      list.all.each do |hit|
        key = hit.primary_key
        page = Page.where(:text_id => key).first
        results.push page
      end
    end
    results
  end

end
