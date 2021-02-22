# frozen_string_literal: true

require_relative 'board'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Game object class
class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def set_board
    board.set_black_first_row
    board.set_black_pawns
    board.set_white_pawns
    board.set_white_first_row
  end
end

g = Game.new
g.set_board
g.board.show_board
