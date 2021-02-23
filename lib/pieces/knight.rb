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

  def knight_move(current_position, target)
    # TODO
  end

  def valid_knight_move?(current_position, target)
    return true if MOVES.include?(coordinate_difference(current_position, target))

    false
  end

  def to_s
    " #{marker} "
  end

  private

  def coordinate_difference(current_position, target)
    current_position.zip(target).map { |x, y| y - x }
  end
end
