# frozen_string_literal: true

require_relative 'piece'

# Rook piece object
class Rook < Piece
  attr_accessor :location, :parent

  def initialize(marker, color, location = nil)
    # use "\u2656" for black, "\u265C" for white
    super(marker, color)
    @location = location
    @possible_moves = []
    @parent = nil
  end

  def valid_move?(current_position, target)
    legal_orthogonal?(current_position, target)
  end

  private

  def move_set
    [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze
  end
end
