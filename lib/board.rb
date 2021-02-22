# frozen_string_literal: true

require_relative 'displayable'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Board class representing the Chess board
class Board
  include Displayable
  attr_reader :cells

  def initialize
    @cells = Array.new(8) { Array.new(8, '   ') }
  end

  def set_board
    # first, set the black pieces, i.e. @cells[0][i] = Rook, Knight... then @cells[1] = all pawns
    # do the same for white
  end

  def set_black_first_row
    @cells[0] =
      [
        Rook.new("\u2656", 'black'), Knight.new("\u2658", 'black'), Bishop.new("\u2657", 'black'),
        Queen.new("\u2655", 'black'), King.new("\u2654", 'black'), Bishop.new("\u2657", 'black'),
        Knight.new("\u2658", 'black'), Rook.new("\u2656", 'black')
      ]
  end

  def set_black_pawns
    (0..7).each { |i| @cells[1][i] = Pawn.new("\u2659", 'black') }
  end
end

x = Board.new
x.set_black_first_row
x.set_black_pawns
x.show_board
