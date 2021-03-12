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

  def bfs(start, target, selected_piece)
    selected_piece.location = start
    discovered = [selected_piece]
    queue = [selected_piece]

    until queue.empty?
      current = queue.shift
      return current if current.location == target

      add_to_discovered_and_queue(current, discovered, queue)
    end
  end

  def add_to_discovered_and_queue(current, discovered, queue)
    current.find_moves.each do |move|
      next if discovered.include?(move)

      discovered << move
      queue << move
      move.parent = current
    end
  end

  def generate_path(start, target, selected_piece)
    last_node = bfs(start, target, selected_piece)
    return if last_node.nil?

    path = retrieve_parent_nodes(last_node)
    path
  end

  def retrieve_parent_nodes(last_node)
    path = [last_node]
    until last_node.parent.nil?
      path.unshift(last_node.parent)
      last_node = last_node.parent
    end
    path
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
