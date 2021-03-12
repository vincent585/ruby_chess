# frozen_string_literal: true

require_relative 'piece'
require './lib/moveable'

# Rook piece object
class Rook < Piece
  include Moveable
  attr_reader :marker, :color
  attr_accessor :location, :parent

  def initialize(marker, color, location = nil)
    # use "\u2656" for black, "\u265C" for white
    super(marker, color)
    @location = location
    @possible_moves = []
    @parent = nil
  end

  def valid_move?(current_position, target)
    (current_position[0] - target[0]).zero? || (current_position[1] - target[1]).zero?
  end

  private

  def move_set
    [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze
  end
end
