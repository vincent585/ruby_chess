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
    # TODO
  end

  private

  def move_set
    [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  end
end

# x = Bishop.new("\u2657", 'black')
# x.find_moves([7, 2])
# x.possible_moves.each { |move| p move.location }
