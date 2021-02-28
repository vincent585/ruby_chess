# frozen_string_literal: true

# Piece super class for all pieces
class Piece
  def initialize(marker, color)
    @marker = marker
    @color = color
  end

  def to_s
    " #{marker} "
  end
end
