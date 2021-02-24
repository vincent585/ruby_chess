# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Game object class
class Game
  include Displayable
  attr_reader :board

  def initialize
    @board = Board.new
    @player_one = Player.new('bob', 'white')
    @player_two = Player.new('john', 'black')
    @current_player = @player_one
  end

  def set_board
    board.set_black_first_row
    board.set_black_pawns
    board.set_white_pawns
    board.set_white_first_row
  end

  def player_turn
    player_turn_prompt
    loop do
      coordinates = board.update_board(select_start, select_target, @current_player)
      return if coordinates

      puts 'Please enter valid coordinates!'
    end
  end

  def select_start
    prompt_for_start
    gets.chomp
  end

  def select_target
    prompt_for_target
    gets.chomp
  end
end

g = Game.new
g.set_board
g.board.show_board
g.player_turn
g.board.show_board
