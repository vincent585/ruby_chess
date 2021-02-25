# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Game object class
class Game
  include Displayable
  attr_reader :board, :players, :current_player

  def initialize
    @board = Board.new
    @players = []
    @current_player = nil
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

  def set_players
    player_color_prompt
    set_player_one
    set_player_two
  end

  def set_current_player
    return @current_player = players.select { |player| player if player.color == 'white' } if current_player.nil?

    @current_player = @current_player == players[0] ? players[1] : players[0]
  end

  def set_player_one
    loop do
      color = valid_color?(select_color)
      return @players << Player.new(1, color) if color

      puts 'Please enter "white" or "black"'
    end
  end

  def set_player_two
    return players << Player.new(2, 'white') if players[0].color == 'black'

    players << Player.new(2, 'black')
  end

  def valid_color?(color)
    color if %w[white black].include?(color)
  end

  def select_color
    gets.chomp.downcase
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
g.set_players
g.set_current_player
p g.current_player
g.board.show_board
g.player_turn
g.board.show_board
