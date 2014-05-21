class SearchEngine
  
  # The maximum of results requested from Solr.
  MAX_RESULTS = 500
  # The amount of boost applied to the score if a part of
  # the input text occurs in the title of an article.
  PAGE_TITLE_BOOST = 0.5
  
  DIMENSION_WORDS_FILE_PATH = Rails.root.to_s + "/lib/resources/dimensionwords.txt"
  
  attr_reader :input, :used_keywords, :dimensionwords
  
  def initialize(text)
    @input = text
    @processor = TextProcessor.new(text)
    @results_lists = ListMerger.new
    @used_keywords = Array.new
    @dimensionwords = Array.new
  end

  # Returns a sorted ResultsList containing the most relevant articles for 
  # the given input.
  def search_results
    @results_lists.clear

    search_for_keywords
    single_list = @results_lists.merge
    
    @used_keywords = single_list.used_keywords
    
    single_list
  end

  private

  # Applies the search only for words that are not dimension words.
  def search_for_keywords
    keywords = filter_dimensionwords(@processor.words)
    keyword_search(keywords)
  end
  
  # Filters the given words_array for dimension words. The filtered out
  # dimension words get stored. Returns an array containing no dimension
  # words.
  def filter_dimensionwords(words_array)
    all_dimensionwords = extract_dimensionwords_from_file(DIMENSION_WORDS_FILE_PATH)
    words = words_array.map(&:downcase)
    keywords =  words - all_dimensionwords
    @dimensionwords = words - keywords   
    keywords
  end
  
  def extract_dimensionwords_from_file(path_to_file)
    file = File.open(path_to_file)
    all_dimensionwords = file.read.split("\n")
    all_dimensionwords = all_dimensionwords.compact.map(&:downcase)   
  end
  # Produces a search request for every word in the keywords_array.
  def keyword_search(keywords_array)
    keywords_array.each do |keyword|
      fulltext_search(keyword)
    end
  end

  # The full-text search is applied to the content of the table Text and 
  # the result get pushed onto the list of results_lists to later merge them
  # together.
  def fulltext_search(text)
      search = Text.search do
        fulltext text do
          fields(:content,:page => PAGE_TITLE_BOOST)
        end
        paginate :page => 1, :per_page => MAX_RESULTS
      end
      
    search_hits = search.hits.map {|hit| SearchHit.new(hit)}
    
    results = ResultsList.new(search_hits, [text])
    @results_lists.push results
  end
  
end
