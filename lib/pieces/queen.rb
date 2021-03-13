# frozen_string_literal: true

require_relative 'piece'

# Queen piece object
class Queen < Piece
  def initialize(marker, color)
    # use "\u2655" for black, "\u265B" for white
    super(marker, color)
  end

  def valid_move?(current_position, target)
    legal_diagonal?(current_position, target) || legal_orthogonal?(current_position, target)
  end

  private

  def move_set
    [[1, 0], [1, 1], [1, -1], [0, 1], [0, -1], [-1, 0], [-1, 1], [-1, -1]].freeze
  end
end
