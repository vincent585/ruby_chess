# frozen_string_literal: true

require_relative 'piece'

# Queen piece object
class Queen < Piece
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2655" for black, "\u265B" for white
    super(marker, color)
  end
end
