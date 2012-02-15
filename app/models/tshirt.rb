require "open-uri"

# Clipart search page and class containing clipart results
SEARCH_URL = 'http://www.customink.com/clipart/search?keyword='
CLIPART_CLASS = "a.browseClipart_clipArtLink"

# Input must have certain amount of characters
MIN_INPUT_LEN = 3

# Only search for words that have a minimum amount of characters
MIN_WORD_LEN = 2

# Specify which clipart search result to use (if set to 0, use first result)
RESULT_NUM = 0

class Tshirt < ActiveRecord::Base

  before_validation :search_clipart
  validates_length_of :caption, :minimum => MIN_INPUT_LEN
  serialize :skipped
  serialize :no_match

  def search_clipart
    @skipped = []
    @no_match = []
    @match = nil
    @clipart = nil

    load_stop_words

    # For each word, search for images that match
    self.caption.split.each_with_index do |word, index|

      @word = word
      @index = index

      next if skip_word? # Skip certain words

      break if found_clipart? # Exit loop once a clipart is found

    end

    assign_attribs

  end

  def load_stop_words
    @stop_words = []
    File.open('stopwords').each { |a| @stop_words << a.downcase.strip }
  end

  def skip_word?
    if @word.size < 2 or @stop_words.include?(@word.downcase.strip)
      @skipped << @index
      return true
    else
      return false
    end
  end

  def found_clipart?
    if cliparts.size >= 1   # If clipart found, save clipart info
      @clipart = cliparts[RESULT_NUM]  
      @match = @index
      return true
    else   # If no clipart found, record index of non-matched word
      @no_match << @index
      return false
    end
  end

  def cliparts
    # CustomInk stores clipart ids as "name" attributes of clipart links.
    # Scrape those attributes.
    cliparts_doc.search(CLIPART_CLASS).collect {|a| a[:name]}
  end

  def cliparts_doc
    Hpricot( open( search_url ) )
  end

  def search_url
    URI.encode(SEARCH_URL + @word)
  end

  def assign_attribs
    self.clipart = @clipart
    self.match = @match
    self.no_match = @no_match
    self.skipped = @skipped
  end

end
