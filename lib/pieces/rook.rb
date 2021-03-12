# frozen_string_literal: true

require_relative 'piece'

# Rook piece object
class Rook < Piece
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2656" for black, "\u265C" for white
    super(marker, color)
  end

  def valid_move?(current_position, target)
    (current_position[0] - target[0]).zero? || (current_position[1] - target[1]).zero?
  end

  private

  def move_set
    [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze
  end
end
