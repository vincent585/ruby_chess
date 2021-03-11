# frozen_string_literal: true

require_relative 'displayable'
require_relative 'player'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Board class representing the Chess board
class Board
  include Displayable
  attr_reader :cells

  LETTER_INDECES = %w[a b c d e f g h].freeze

  def initialize
    @cells = Array.new(8) { Array.new(8, '   ') }
  end

  def valid_coordinates?(coordinates, current_player)
    on_the_board?(coordinates) &&
      different_cell?(coordinates) &&
      piece_selected?(coordinates, current_player) &&
      cell_not_occupied?(coordinates, current_player)
  end

  def update_board(start, target, current_player)
    coordinates = convert_coordinates(start, target)
    return nil unless valid_coordinates?(coordinates, current_player) && legal_piece_move?(coordinates)

    @cells[coordinates[2]][coordinates[3]] = @cells[coordinates[0]][coordinates[1]]
    @cells[coordinates[0]][coordinates[1]] = '   '
  end

  def set_black_first_row
    @cells[0] =
      [
        Rook.new("\u2656", 'black'), Knight.new("\u2658", 'black'), Bishop.new("\u2657", 'black'),
        Queen.new("\u2655", 'black'), King.new("\u2654", 'black'), Bishop.new("\u2657", 'black'),
        Knight.new("\u2658", 'black'), Rook.new("\u2656", 'black')
      ]
  end

  def set_white_first_row
    @cells[7] =
      [
        Rook.new("\u265C", 'white'), Knight.new("\u265E", 'white'), Bishop.new("\u265D", 'white'),
        Queen.new("\u265B", 'white'), King.new("\u265A", 'white'), Bishop.new("\u265D", 'white'),
        Knight.new("\u265E", 'white'), Rook.new("\u265C", 'white')
      ]
  end

  def set_black_pawns
    (0..7).each { |i| @cells[1][i] = Pawn.new("\u2659", 'black') }
  end

  def set_white_pawns
    (0..7).each { |i| @cells[6][i] = Pawn.new("\u265F", 'white') }
  end

  private

  def different_cell?(coordinates)
    coordinates[0..1] != coordinates[2..3]
  end

  def piece_selected?(coordinates, current_player)
    start = @cells[coordinates[0]][coordinates[1]]
    start != '   ' && start.color == current_player.color
  end

  def on_the_board?(coordinates)
    coordinates.all? { |coordinate| coordinate.between?(0, 7) }
  end

  def cell_not_occupied?(coordinates, current_player)
    @cells[coordinates[2]][coordinates[3]] == '   ' || not_friendly_piece?(coordinates, current_player)
  end

  def not_friendly_piece?(coordinates, current_player)
    @cells[coordinates[2]][coordinates[3]].color != current_player.color
  end

  def legal_piece_move?(coordinates)
    selected_piece = @cells[coordinates[0]][coordinates[1]]
    start = coordinates[0..1]
    target = coordinates[2..3]
    path_clear?(start, target, selected_piece) && selected_piece.valid_move?(start, target)
  end

  def path_clear?(start, target, selected_piece)
    path = generate_path(start, target, selected_piece)
    path[1...-1].each do |piece|
      p piece.location
      return false unless cells[piece.location[0]][piece.location[1]] == '   '
    end
    true
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

  def convert_coordinates(start, target, coordinates = [start, target])
    coordinates = coordinates.map(&:chars)
    coordinates.map do |coordinate|
      coordinate.map do |c|
        LETTER_INDECES.include?(c) ? LETTER_INDECES.index(c) : c.to_i - 1
      end.reverse
    end.flatten
  end
end
