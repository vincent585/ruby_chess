# frozen_string_literal: true

require_relative 'displayable'

# Board class representing the Chess board
class Board
  include Displayable
  attr_reader :cells

  LETTER_INDECES = %w[A B C D E F G H].freeze

  def initialize
    @cells = Array.new(8) { Array.new(8, '   ') }
  end

  def update_board(start, target)
    coordinates = convert_coordinates(start, target)
    @cells[coordinates[2]][coordinates[3]] = @cells[coordinates[0]][coordinates[1]]
    @cells[coordinates[0]][coordinates[1]] = '   '
    show_board
  end

  def convert_coordinates(start, target, coordinates = [start, target])
    coordinates = coordinates.map(&:chars)
    coordinates.map do |coordinate|
      coordinate.map do |c|
        LETTER_INDECES.include?(c.upcase) ? LETTER_INDECES.index(c.upcase) : c.to_i - 1
      end.reverse
    end.flatten
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
end
