class TextMiningController < ApplicationController
  def search
    @text = params[:search_text]
    @pages = Array.new

    search = Sunspot.search(Text) do |query|
      query.fulltext @text
    end
    result = search.results

    if result.present?
      result.each do |result|
        id = result.page_id
        @pages.push(Page.where(:page_id => id).first)
      end
    end

  end

  def results
  end
end
