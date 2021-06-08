# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'check_detection'
require_relative 'castling'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Game object class
class Game
  include Displayable
  include CheckDetection
  include Castling
  attr_reader :board, :players, :current_player
  attr_accessor :active_pieces, :can_attack_king

  def initialize
    @board = Board.new
    @players = []
    @current_player = nil
    @active_pieces = []
    @can_attack_king = []
  end

  def set_board
    board.set_black_first_row
    board.set_black_pawns
    board.set_white_pawns
    board.set_white_first_row
  end

  def player_turns
    generate_piece_moves
    loop do
      board.show_board
      return game_over if checkmate?

      player_turn
      set_current_player
    end
  end

  def player_turn
    player_turn_prompt
    loop do
      start = validated_start
      if castling_notation?(start) && can_castle?(start)
        return @board = perform_castling(start)
      elsif castling_notation?(start)
        puts 'You cannot castle now'
        next
      end

      target = validated_target
      updated_board = generate_temp_board(start, target)
      generate_piece_moves(updated_board) unless updated_board.nil?
      king = locate_king
      return @board = updated_board if valid_move?(updated_board, king)
    end
  end

  def valid_move?(updated_board, king)
    if updated_board.nil?
      puts 'Please enter valid coordinates!'
      false
    elsif player_not_in_check?(king)
      true
    else
      puts 'That is not a legal move!'
      false
    end
  end

  def set_players
    player_color_prompt
    set_player_one
    set_player_two
  end

  def set_current_player
    return @current_player = players.find { |player| player.color == 'white' } if current_player.nil?

    @current_player = @current_player == players[0] ? players[1] : players[0]
  end

  def set_player_one
    loop do
      color = select_color
      verified_color = valid_color?(color)
      return @players << Player.new(1, color) if verified_color

      puts 'Please enter "white" or "black"'
    end
  end

  def set_player_two
    return players << Player.new(2, 'white') if players[0].color == 'black'

    players << Player.new(2, 'black')
  end

  def valid_color?(color)
    %w[white black].include?(color)
  end

  def generate_temp_board(start, target)
    copy = Marshal.load(Marshal.dump(board))
    copy.update_board(start, target, @current_player)
  end

  def player_not_in_check?(king)
    return false if double_check?(king.location) || single_check?(king.location)

    true
  end

  def castling_notation?(coordinate)
    ['o-o', 'o-o-o'].include?(coordinate)
  end

  def valid_input?(coordinate)
    return false unless coordinate.length == 2

    coordinate[0].between?('a', 'h') && coordinate[1].to_i.between?(1, 8)
  end

  def validated_start
    loop do
      user_input = select_start
      return user_input if castling_notation?(user_input)

      verified_input = valid_input?(user_input)
      return user_input if verified_input

      puts 'Please enter valid coordinates!'
    end
  end

  def validated_target
    loop do
      user_input = select_target
      verified_input = valid_input?(user_input)
      return user_input if verified_input

      puts 'Please enter valid target coordinates!'
    end
  end

  def select_color
    gets.chomp.downcase
  end

  def select_start
    prompt_for_start
    gets.chomp.downcase
  end

  def select_target
    prompt_for_target
    gets.chomp.downcase
  end
end

# CHECKMATE SETUP
g = Game.new
bking = King.new("\u2654", 'black', [0, 4])
bpwn = Pawn.new("\u2659", 'black', [1, 5])
bpwn2 = Pawn.new("\u2659", 'black', [1, 3])
queen = Queen.new("\u265B", 'white', [7, 4])
rook = Rook.new("\u265C", 'white', [1, 0])
wking = King.new("\u265A", 'white', [7, 0])
bpwn3 = Pawn.new("\u2659", 'black', [3, 4])
positions =
  [
    ['   ', '   ', '   ', '   ', bking, '   ', '   ', '   '],
    [rook, '   ', '   ', bpwn2, '   ', bpwn, '   ', '   '],
    ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    ['   ', '   ', '   ', '   ', bpwn3, '   ', '   ', '   '],
    ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    [wking, '   ', '   ', '   ', queen, '   ', '   ', '   ']
  ]
g.board.instance_variable_set(:@cells, positions)
g.set_players
g.set_current_player
g.player_turns
