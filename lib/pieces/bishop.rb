# frozen_string_literal: true

require_relative 'piece'

# Bishop piece object
class Bishop < Piece
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2657" for black, "\u265D" for white
    super(marker, color)
  end
end
