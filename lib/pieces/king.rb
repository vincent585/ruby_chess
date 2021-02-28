# frozen_string_literal: true

require_relative 'piece'

# King piece object
class King < Piece
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2654" for black and "\u265A" for white
    super(marker, color)
  end
end
