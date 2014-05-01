class SearchEngine

  attr_reader :input, :used_keywords
  def initialize(text)
    @input = text
    @processor = TextProcessor.new(text)
    @result_lists = ListMerger.new
    @used_keywords = Array.new
  end

  def search_results
    @result_lists.clear

    search_for_keywords
    #fulltext_search(@input)
    
    single_list = @result_lists.merge
    @used_keywords = single_list.used_keywords
    single_list
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
  
  def keyword_search(keywords_array)
    keywords_array.each do |keyword|
      fulltext_search(keyword)
    end
  end

  def fulltext_search(text)
      search = Text.search do
        fulltext text do
          fields(:content,:page => 1)
          phrase_fields :content => 2000000.0
          query_phrase_slop 10000
        end
        paginate :page => 1, :per_page => 10000
      end
      

    results = ResultsList.new(search.hits, [text])
    @result_lists.push results
  end

end