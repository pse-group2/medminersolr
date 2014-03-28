class TextMiningController < ApplicationController
  def search
   @text = params[:search_text]
   @pages = Array.new

   search = Sunspot.search(Text) do |query|#Text
	query.fulltext @text
   end
   result = search.results
   
	if result.present? 
	result.each do |result|
		id = result.page_id
		#id_page = Revision.where(:rev_text_id => id).first.rev_page
		@pages.push(Page.where(:page_id => id).first)
		end
	end
	

  end

  def results
  end
end
