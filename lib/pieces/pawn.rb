# frozen_string_literal: true

require_relative 'piece'

# Pawn piece object
class Pawn < Piece
  def initialize(marker, color)
    # use "\u2659" for black, "\u265F" for white
    super(marker, color)
    @moved = false
  end

  def valid_move?(current_position, target)
    move_type = coordinate_difference(current_position, target)
    return false if move_type == [2, 0] && @moved == true

    move_set.include?(move_type)
  end

  private

  def move_set
    [[1, 0], [2, 0], [1, 1], [1, -1]].freeze
  end
end
