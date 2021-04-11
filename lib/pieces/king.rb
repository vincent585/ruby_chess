# frozen_string_literal: true

require_relative 'piece'

# King piece object
class King < Piece
  def initialize(marker, color, location)
    # use "\u2654" for black and "\u265A" for white
    super(marker, color, location)
  end

  def valid_move?(current_position, target)
    move_set.include?(coordinate_difference(current_position, target))
  end

  private

  def move_set
    [
      [1, 1], [-1, 1], [1, -1], [-1, -1], # diagonal moves
      [1, 0], [-1, 0], [0, 1], [0, -1] # horizontal and vertical moves
    ].freeze
  end
end
