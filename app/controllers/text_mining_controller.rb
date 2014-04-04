class TextMiningController < ApplicationController
  def search
    @text = params[:search_text]
    @pages = Array.new

    unless @text.blank? then
      engine = SearchEngine.new(@text)
      @pages = engine.search_results
    end

  end

  def results
  end
end
