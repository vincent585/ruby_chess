# frozen_string_literal: true

# module for shared movement methods
module Moveable
  def legal_diagonal?(current_position, target)
    (current_position[0] - target[0]).abs == (current_position[1] - target[1]).abs
  end

  def legal_orthogonal?(current_position, target)
    (current_position[0] - target[0]).zero? || (current_position[1] - target[1]).zero?
  end

  def coordinate_difference(current_position, target)
    return current_position.zip(target).map { |x, y| y - x } if color == 'black'
    return current_position.zip(target).map { |x, y| x - y } if color == 'white'
  end
end
