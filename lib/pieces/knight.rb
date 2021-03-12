# frozen_string_literal: true

require_relative 'piece'

# Knight piece object
class Knight < Piece
  def initialize(marker, color)
    # use "\u2658" for black, "\u265E" for white to display properly in terminal.
    super(marker, color)
  end

  def valid_move?(current_position, target)
    move_set.include?(coordinate_difference(current_position, target))
  end

  private

  def move_set
    [
      [1, 2], [2, 1], [-1, 2], [-2, 1], # upward moves
      [1, -2], [2, -1], [-1, -2], [-2, -1] # downward moves
    ].freeze
  end
end
