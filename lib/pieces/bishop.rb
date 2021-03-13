# frozen_string_literal: true

require_relative 'piece'

# Bishop piece object
class Bishop < Piece
  def initialize(marker, color)
    # use "\u2657" for black, "\u265D" for white
    super(marker, color)
  end

  def valid_move?(current_position, target)
    legal_diagonal?(current_position, target)
  end

  private

  def move_set
    [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
  end
end
