require "open-uri"

# Clipart search page and class containing clipart results
SEARCH_URL = 'http://www.customink.com/clipart/search?keyword='
CLIPART_CLASS = "a.browseClipart_clipArtLink"

# Only search for words with certain amount of characters
MIN_WORD_LEN = 4

# Use first clipart result given
RESULT_NUM = 0


class TshirtsController < ApplicationController
  def index
    @tshirts = Tshirt.all
  end
  def show
    @tshirt = Tshirt.find(params[:id])
    @no_match_words = @tshirt.no_match.map { |i|
      '"' + @tshirt.caption.split[i].to_s + '"'
    }.join(", ")
    if !@tshirt.has_match.nil?
      @matched_word = @tshirt.caption.split[@tshirt.has_match.to_i]
    end
  end
  def new
    @tshirt = Tshirt.new
  end
  def create
    @tshirt = Tshirt.new(params[:tshirt])
    @tshirt.no_match = []
    @tshirt.has_match = []
    @tshirt.short = []
    # For each word, search for images that match

    @tshirt.caption.split.each_with_index do |word, index|
      if word.size < MIN_WORD_LEN
        @tshirt.short << index
        next
      end
      search_url = URI.encode(SEARCH_URL + word)
      cliparts_doc = Hpricot(open(search_url))

      # Scrape "name" attributes of clipart links.
      # That's where CustomInk stores clipart ids.
      cliparts = cliparts_doc.search(CLIPART_CLASS).collect {
        |a| a[:name]
      }
      if cliparts.size > 0
        # If matches found, save one of the matches and break.
        @tshirt.has_match = index
        @tshirt.clipart = cliparts[RESULT_NUM]
        break
      else
        # If no match found, record index of unmatched word. Keep searching.
        @tshirt.no_match << index
      end
    end
    begin
      @tshirt.save!
    rescue
      abort("invalid!")
    end
#    redirect_to tshirt_path(@tshirt)
  end
  def edit
    @tshirt = Tshirt.find(params[:id])
  end
  def update
    @tshirt = Tshirt.find(params[:id])
    @tshirt.update_attributes(params[:tshirt])
    redirect_to tshirt_path(@tshirt)
  end
  def destroy
    Tshirt.find(params[:id]).destroy
    redirect_to tshirts_path
  end
end
