# frozen_string_literal: true

# Queen piece object
class Queen
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2655" for black, "\u265B" for white
    @marker = marker
    @color = color
  end

  def to_s
    " #{marker} "
  end
end
