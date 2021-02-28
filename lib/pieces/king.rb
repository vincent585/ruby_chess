# frozen_string_literal: true

require_relative 'piece'

# King piece object
class King < Piece
  attr_reader :marker, :color, :possible_moves

  def initialize(marker, color)
    # use "\u2654" for black and "\u265A" for white
    super(marker, color)
    @possible_moves = []
  end

  def valid_move?(current_position, target)
    @possible_moves = find_possible_moves(current_position)
    possible_moves.include?(target)
  end

  def find_possible_moves(current_position)
    # TODO
  end
end
