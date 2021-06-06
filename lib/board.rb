# frozen_string_literal: true

require_relative 'displayable'
require_relative 'board_validation'
require_relative 'player'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Board class representing the Chess board
class Board
  include BoardValidation
  include Displayable
  attr_reader :cells

  LETTER_INDECES = %w[a b c d e f g h].freeze

  def initialize
    @cells = Array.new(8) { Array.new(8, '   ') }
  end

  def valid_coordinates?(coordinates, current_player)
    start = [coordinates[0], coordinates[1]]
    target = [coordinates[2], coordinates[3]]
    different_cell?(start, target) &&
      piece_selected?(start, current_player) &&
      cell_not_occupied?(start, target)
  end

  def legal_piece_move?(coordinates)
    selected_piece = @cells[coordinates[0]][coordinates[1]]
    start = coordinates[0..1]
    target = coordinates[2..3]
    return selected_piece.valid_move?(start, target, self) if selected_piece.is_a?(Pawn)

    selected_piece.valid_move?(start, target) && path_clear?(start, target, selected_piece)
  end

  def update_board(start, target, current_player)
    coordinates = convert_coordinates(start, target)
    return nil unless valid_coordinates?(coordinates, current_player) && legal_piece_move?(coordinates)

    update_moved_status(coordinates)
    move_piece(coordinates)
    self
  end

  def set_black_first_row
    @cells[0] =
      [
        Rook.new("\u2656", 'black', [0, 0]), Knight.new("\u2658", 'black', [0, 1]), Bishop.new("\u2657", 'black', [0, 2]),
        Queen.new("\u2655", 'black', [0, 3]), King.new("\u2654", 'black', [0, 4]), Bishop.new("\u2657", 'black', [0, 5]),
        Knight.new("\u2658", 'black', [0, 6]), Rook.new("\u2656", 'black', [0, 7])
      ]
  end

  def set_white_first_row
    @cells[7] =
      [
        Rook.new("\u265C", 'white', [7, 0]), Knight.new("\u265E", 'white', [7, 1]), Bishop.new("\u265D", 'white', [7, 2]),
        Queen.new("\u265B", 'white', [7, 3]), King.new("\u265A", 'white', [7, 4]), Bishop.new("\u265D", 'white', [7, 5]),
        Knight.new("\u265E", 'white', [7, 6]), Rook.new("\u265C", 'white', [7, 7])
      ]
  end

  def set_black_pawns
    (0..7).each { |i| @cells[1][i] = Pawn.new("\u2659", 'black', [1, i]) }
  end

  def set_white_pawns
    (0..7).each { |i| @cells[6][i] = Pawn.new("\u265F", 'white', [6, i]) }
  end

  private

  def move_piece(coordinates)
    @cells[coordinates[2]][coordinates[3]] = @cells[coordinates[0]][coordinates[1]]
    @cells[coordinates[0]][coordinates[1]] = '   '
    update_piece_location(coordinates)
  end

  def update_piece_location(coordinates)
    @cells[coordinates[2]][coordinates[3]].location = [coordinates[2], coordinates[3]]
  end

  def update_moved_status(coordinates)
    @cells[coordinates[0]][coordinates[1]].moved = true
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
