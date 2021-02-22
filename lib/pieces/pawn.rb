# frozen_string_literal: true

# Pawn piece object
class Pawn
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2659" for black, "\u265F" for white
    @marker = marker
    @color = color
  end

  def to_s
    " #{marker} "
  end
end
