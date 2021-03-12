# frozen_string_literal: true

require_relative 'piece'
require './lib/moveable'

# Queen piece object
class Queen < Piece
  include Moveable
  attr_reader :marker, :color
  attr_accessor :location, :parent

  def initialize(marker, color, location = nil)
    # use "\u2655" for black, "\u265B" for white
    super(marker, color)
    @location = location
    @possible_moves = []
    @parent = nil
  end

  def valid_move?(current_position, target)
    legal_diagonal?(current_position, target) || legal_orthogonal?(current_position, target)
  end

  private

  def move_set
    [[1, 0], [1, 1], [1, -1], [0, 1], [0, -1], [-1, 0], [-1, 1], [-1, -1]].freeze
  end
end
