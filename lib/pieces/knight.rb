# frozen_string_literal: true

# Knight piece object
class Knight
  MOVES =
    [
      [1, 2], [2, 1], [-1, 2], [-2, 1], # upward moves
      [1, -2], [2, -1], [-1, -2], [-2, -1] # downward moves
    ].freeze

  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2658" for black, "\u265E" for white to display properly in terminal.
    @marker = marker
    @color = color
  end

  def valid_move?(current_position, target)
    MOVES.include?(coordinate_difference(current_position, target)) ? true : false
  end

  def to_s
    " #{marker} "
  end

  private

  def coordinate_difference(current_position, target)
    current_position.zip(target).map { |x, y| y - x }
  end
end
