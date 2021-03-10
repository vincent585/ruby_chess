# frozen_string_literal: true

require_relative 'piece'

# King piece object
class King < Piece
  MOVES =
    [
      [1, 1], [-1, 1], [1, -1], [-1, -1], # diagonal moves
      [1, 0], [-1, 0], [0, 1], [0, -1] # horizontal and vertical moves
    ].freeze

  attr_reader :marker, :color, :possible_moves

  def initialize(marker, color)
    # use "\u2654" for black and "\u265A" for white
    super(marker, color)
  end

  def valid_move?(current_position, target)
    MOVES.include?(coordinate_difference(current_position, target))
  end

  private

  def coordinate_difference(current_position, target)
    current_position.zip(target).map { |x, y| y - x }
  end

  def in_check?
    # TODO
  end

  def checkmate?
    # TODO
  end
end
