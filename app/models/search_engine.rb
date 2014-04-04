class SearchEngine

  attr_reader :input
  def initialize(text)
    @input = text
    @processor = TextProcessor.new(text)
    @result_lists = Array.new
  end

  def search_results
    @result_lists.clear

    #search_for_nouns
    #tree_search
    search_for_keywords
    @result_lists.first
  end

  private

  def search_for_nouns
    @processor.nouns.each do |noun|
      fulltext_search(noun)
    end
  end

  def search_for_keywords
    keyword_search(@processor.keywords)
  end

  def fulltext_search(text)
    search = Sunspot.search(Text) do |query|
      query.fulltext text

      order_by(:score, :desc)
      order_by(:average_rating, :desc)
    end

    results = search.results.map {|result| result.page }
    @result_lists.push results
  end

  def title_search(text)
    search = Sunspot.search(Page) do |query|
      query.fulltext page_title
    end
    @result_lists.push search.results
  end

  def keyword_search(keywords_array)

    search = Sunspot.search(Text) do |query|
      query.keywords keywords_array
    end

    results = search.results.map {|result| result.page }
    @result_lists.push results
  end

  def tree_search
    root_node = @processor.parse_tree
    root_node.children.each do |child|

      @result_lists.push fulltext_search(child.to_s)
    end
  end
end