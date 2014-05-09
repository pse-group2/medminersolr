class SearchEngine

  attr_reader :input, :used_keywords
  def initialize(text)
    @input = text
    @processor = TextProcessor.new(text)
    @result_lists = ListMerger.new
    @used_keywords = Array.new
    @dimensionwords = Array.new
  end

  def search_results
    @result_lists.clear

    search_for_keywords
    
    single_list = @result_lists.merge
    @used_keywords = single_list.used_keywords
    mark_hits_containing_dimensionwords(single_list)
    single_list
  end

  private

  def search_for_keywords
    reduced_words = reduce_keywords
    keyword_search(reduced_words)
  end
  
  def reduce_keywords
    f = File.open('./solr/conf/dimensionwords.txt')
    all_dimensionwords = Array.new
    all_dimensionwords = f.read.split("\n")
    reduced_words = @processor.words.map(&:downcase) - all_dimensionwords.compact.map(&:downcase)
    @dimensionwords = @processor.words.map(&:downcase) - reduced_words
    reduced_words
    
  end
  
  def keyword_search(keywords_array)
    keywords_array.each do |keyword|
      fulltext_search(keyword)
    end
  end

  def fulltext_search(text)
      search = Text.search do
        fulltext text do
          fields(:content,:page => 0.5)
        end
        paginate :page => 1, :per_page => 1000
      end
      
    search_hits = search.hits.map {|hit| SearchHit.new(hit)}
    
    results = ResultsList.new(search_hits, [text])
    @result_lists.push results
  end
  
  def mark_hits_containing_dimensionwords(results_list)
    results_list.all.each do |hit|
      key = hit.primary_key
      @dimensionwords.each do |word|
        rows = Text.where(:text_id => key).where("content LIKE ?", "%#{word}%")
        unless rows.size < 1 then
          hit.contains_dimensionword = true
        end
      end
    end
  end

end