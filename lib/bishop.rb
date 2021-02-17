# frozen_string_literal: true

# Bishop piece object
class Bishop
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2657" for black, "\u265D" for white
    @marker = marker
    @color = color
  end
end
