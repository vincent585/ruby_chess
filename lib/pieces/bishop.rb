# frozen_string_literal: true

require_relative 'piece'
require './lib/moveable'

# Bishop piece object
class Bishop < Piece
  attr_reader :marker, :color, :possible_moves

  def initialize(marker, color)
    # use "\u2657" for black, "\u265D" for white
    super(marker, color)
    @possible_moves = []
  end

  def valid_move?(current_position, target)
    # TODO
  end

  private

  def move_set
    [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  end
end
