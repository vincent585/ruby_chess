# frozen_string_literal: true

require_relative 'piece'
require './lib/moveable'

# King piece object
class King < Piece
  include Moveable
  attr_reader :marker, :color, :possible_moves

  def initialize(marker, color)
    # use "\u2654" for black and "\u265A" for white
    super(marker, color)
  end

  def valid_move?(current_position, target)
    move_set.include?(coordinate_difference(current_position, target))
  end

  def in_check?
    # TODO
  end

  def checkmate?
    # TODO
  end

  private

  def move_set
    [
      [1, 1], [-1, 1], [1, -1], [-1, -1], # diagonal moves
      [1, 0], [-1, 0], [0, 1], [0, -1] # horizontal and vertical moves
    ].freeze
  end
end
