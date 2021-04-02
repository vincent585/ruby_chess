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

    return valid_forward_move? if forward_move?(move_type)
    return valid_diagonal_move? if diagonal_move?(move_type)
  end

  private

  def forward_move?(move_type)
    forward_moves = [move_set[0], move_set[1]]
    forward_moves.include?(move_type)
  end

  def valid_forward_move?
    # TODO
  end

  def diagonal_move?(move_type)
    diagonal_moves = [move_set[2], move_set[3]]
    diagonal_moves.include?(move_type)
  end

  def valid_diagonal_move?
    # TODO
  end

  def move_set
    [[1, 0], [2, 0], [1, 1], [1, -1]].freeze
  end
end

foo = Pawn.new("\u2659", 'black')
p foo.valid_move?([1, 0], [3, 0])
