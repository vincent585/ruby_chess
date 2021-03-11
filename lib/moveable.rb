# frozen_string_literal: true

# module for shared movement methods
module Moveable
  def find_moves(current_position)
    move_set.each do |move|
      new_coordinates = move.zip(current_position).map { |x, y| x + y if (x + y).between?(0, 7) }
      @possible_moves << new_coordinates unless new_coordinates.include?(nil)
    end
  end

  def coordinate_difference(current_position, target)
    current_position.zip(target).map { |x, y| y - x }
  end
end
