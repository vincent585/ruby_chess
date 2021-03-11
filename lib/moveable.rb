# frozen_string_literal: true

# module for shared movement methods as well as graph creation for moves
module Moveable
  def find_moves(current_position = @location, possible_moves = @possible_moves)
    move_set.each do |move|
      new_coordinates = set_new_coordinates(move, current_position)
      possible_moves << self.class.new(marker, color, new_coordinates) unless new_coordinates.include?(nil)
    end
    possible_moves
  end

  def coordinate_difference(current_position, target)
    current_position.zip(target).map { |x, y| y - x }
  end

  def set_new_coordinates(move, current_position)
    move.zip(current_position).map do |x, y|
      x + y if (x + y).between?(0, 7)
    end
  end
end
