class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates_presence_of :full_url
  validate :validate_full_url

  # bitjective function was shamelessly stolen from: https://gist.github.com/zumbojo/1073996
  def short_code
    i = id
    return nil if i == 0 || i.nil?
    s = ''
    base = CHARACTERS.length
    while i > 0
      s << CHARACTERS[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def public_attributes
    self.attributes.slice('full_url', 'short_code')
  end

  def self.find_by_short_code(short_code)
    # based on base2dec() in Tcl translation
    # at http://rosettacode.org/wiki/Non-decimal_radices/Convert#Ruby
    i = 0
    base = CHARACTERS.length
    short_code.each_char { |c| i = i * base + CHARACTERS.index(c) }
    i
    ShortUrl.find_by(id: i)
  end

  def update_title!
    self.title = Nokogiri::HTML(Net::HTTP.get(URI(full_url))).at_css('title').text
    self.save
  end

  private

  def validate_full_url
    if full_url.nil? || !full_url.match?(URI::DEFAULT_PARSER.make_regexp(%w(http https)))
      errors.add(:full_url, 'is not a valid url')
    end
  end

end
