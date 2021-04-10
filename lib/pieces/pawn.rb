# frozen_string_literal: true

require_relative 'piece'

# Pawn piece object
class Pawn < Piece
  attr_accessor :moved

  def initialize(marker, color, location)
    # use "\u2659" for black, "\u265F" for white
    super(marker, color, location)
    @moved = false
  end

  def valid_move?(current_position, target)
    move = coordinate_difference(current_position, target)
    return false if move == [2, 0] && @moved == true

    move_set.include?(move)
  end

  private

  def move_set
    [[1, 0], [2, 0], [1, 1], [1, -1]].freeze
  end
end
