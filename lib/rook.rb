# frozen_string_literal: true

# Rook piece object
class Rook
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2656" for black, "\u265C" for white
    @marker = marker
    @color = color
  end
end
