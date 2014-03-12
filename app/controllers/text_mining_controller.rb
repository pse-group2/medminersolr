class TextMiningController < ApplicationController
  def search
   @text = params[:search_text]
    
  end

  def results
  end
end
