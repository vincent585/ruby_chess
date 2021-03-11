# frozen_string_literal: true

require_relative 'piece'
require './lib/moveable'

# Bishop piece object
class Bishop < Piece
  include Moveable
  attr_reader :marker, :color, :possible_moves
  attr_accessor :location, :parent

  def initialize(marker, color, location = nil)
    # use "\u2657" for black, "\u265D" for white
    super(marker, color)
    @location = location
    @possible_moves = []
    @parent = nil
  end

  def valid_move?(current_position, target)
    (current_position[0] - target[0]).abs == (current_position[1] - target[1]).abs
  end

  private

  def move_set
    [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  end
end
