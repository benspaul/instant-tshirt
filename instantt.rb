require "rubygems"
require "open-uri"
require "hpricot"
require "launchy"

class InstantT

# Locations of CustomInk search page and clipart
BASE_URL = 'http://www.customink.com/clipart/'
GENERIC_SEARCH_URL = BASE_URL + 'search?keyword='
GENERIC_CLIPART_URL = BASE_URL + 'manipulate?lockRatio=true&width=200&height=200&blackwhite=true&clipart_id='

def initialize(query)
  @query = URI.escape(query.strip)
  @search_url = GENERIC_SEARCH_URL + @query
  @doc = Hpricot(open(@search_url))
end

def load_clipart_ids
  # Use hpricot gem to find "name" attributes of clipart links.
  # These "name" attributes are where CustomInk puts clipart ids.
  @doc.search("a.browseClipart_clipArtLink").collect { |a| a[:name] }
end

def clipart_url(result_num)
  clipart_url = nil # start with assumption that there are no results
  clipart_ids = load_clipart_ids
  if clipart_ids.size >= 1
    clipart_url = GENERIC_CLIPART_URL + clipart_ids[result_num]
  end
  clipart_url
end

end

if __FILE__ == $0
    # Use first clipart result given
    result_num = 0
    
    # Only search for words 3 characters or longer
    min_word_len = 3

    # Ask user for search terms
    print "\nWhat would you like your t-shirt to say? "
    resp = gets.strip

    # Validate
    abort("\nYou must enter at least one word.") if resp.size < 1

    # Search images matching each word in sequence
    resp.split.each do |query|
      if query.size < min_word_len
        print "\nSkipping short word \"" + query + "\"..."
        next
      end
      print "\nSearching for an image matching \"" + query + "\"..."
      instantt = InstantT.new(query)
      clipart_to_use = instantt.clipart_url(result_num)
      if clipart_to_use.nil?
        # If no match found, continue to try next word. Don't exit.
        print "sorry, no matches.\n"
      else
        # If match found, show image and exit
        print "found one!\n"
        Launchy.open(clipart_to_use)
        exit
      end
    end
end
