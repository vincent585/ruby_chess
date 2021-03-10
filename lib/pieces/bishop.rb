# frozen_string_literal: true

require_relative 'piece'

# Bishop piece object
class Bishop < Piece
  MOVES = [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze

  attr_reader :marker, :color, :possible_moves

  def initialize(marker, color)
    # use "\u2657" for black, "\u265D" for white
    super(marker, color)
    @possible_moves = []
  end

  def valid_move?(current_position, target)
    possible_moves.each { |diagonal| diagonal.include?(target) }
  end

  def get_moves(current_position)
    # TODO
  end
end
