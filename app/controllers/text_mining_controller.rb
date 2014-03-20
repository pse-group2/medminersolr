class TextMiningController < ApplicationController
  def search
   @text = params[:search_text]
   
   t = Text.search do 
   	fulltext @text
   end

   @result = t.results

  end

  def results
  end
end
