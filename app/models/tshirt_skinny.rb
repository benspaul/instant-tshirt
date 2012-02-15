# Only search for words with certain amount of characters
MIN_INPUT_LEN = 8

class Tshirt < ActiveRecord::Base
  validates_length_of :caption, :minimum => MIN_INPUT_LEN
  validates_presence_of :clipart
  serialize :no_match

  def fetch_clipart
  end

end
