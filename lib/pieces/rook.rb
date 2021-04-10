# frozen_string_literal: true

require_relative 'piece'

# Rook piece object
class Rook < Piece
  def initialize(marker, color, location)
    # use "\u2656" for black, "\u265C" for white
    super(marker, color, location)
  end

  def valid_move?(current_position, target)
    legal_orthogonal?(current_position, target)
  end

  private

  def move_set
    [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze
  end
end
