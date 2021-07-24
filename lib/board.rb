# frozen_string_literal: true

require_relative 'displayable'
require_relative 'board_validation'
require_relative 'player'
Dir['./lib/pieces/*.rb'].sort.each(&method(:require))

# Board class representing the Chess board
class Board
  include BoardValidation
  include Displayable
  attr_accessor :cells

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
    return nil if en_passant?(cells[coordinates[0]][coordinates[1]], coordinates) && !cells[coordinates[0]][coordinates[1]].legal_en_passant?(coordinates, self)
    
    update_moved_status(coordinates)
    move_piece(coordinates)
    @cells[coordinates[2]][coordinates[3]] = upgrade_piece(coordinates) if pawn_upgrade_available?(coordinates)
    reset_vulnerability(current_player)
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

  def upgrade_piece(coordinates)
    piece_to_upgrade = @cells[coordinates[2]][coordinates[3]]
    color = piece_to_upgrade.color
    selection = select_upgrade_piece
    if color == 'white'
      case selection
      when 'r'
        Rook.new("\u265C", 'white', [0, piece_to_upgrade.location.last])
      when 'q'
        Queen.new("\u265B", 'white', [0, piece_to_upgrade.location.last])
      when 'b'
        Bishop.new("\u265D", 'white', [0, piece_to_upgrade.location.last])
      when 'k'
        Knight.new("\u265E", 'white', [0, piece_to_upgrade.location.last])
      end
    elsif color == 'black'
      case selection
      when 'r'
        Rook.new("\u2656", 'black', [7, piece_to_upgrade.location.last])
      when 'q'
        Queen.new("\u2655", 'black', [7, piece_to_upgrade.location.last])
      when 'b'
        Bishop.new("\u2657", 'black', [7, piece_to_upgrade.location.last])
      when 'k'
        Knight.new("\u2658", 'black', [7, piece_to_upgrade.location.last])
      end
    end
  end

  def select_upgrade_piece
    puts 'Pawn upgrade available. Please enter "r" for rook, "q" for queen, "b" for bishop" or "k" for knight.'
    loop do
      input = gets.chomp.downcase
      return input if valid_upgrade_piece?(input)

      puts "#{input} is not a valid selection."
    end
  end

  def valid_upgrade_piece?(input)
    return false unless input.length == 1

    %w[r q b k].include?(input)
  end

  def pawn_upgrade_available?(coordinates)
    piece = @cells[coordinates[2]][coordinates[3]]
    return true if white_pawn_at_other_side?(piece)
    return true if black_pawn_at_other_side?(piece)

    false
  end

  def white_pawn_at_other_side?(piece)
    piece.is_a?(Pawn) && piece.color == 'white' && piece.location.first.zero?
  end

  def black_pawn_at_other_side?(piece)
    piece.is_a?(Pawn) && piece.color == 'black' && piece.location.first == 7
  end

  def move_piece(coordinates)
    start = @cells[coordinates[0]][coordinates[1]]
    start.vulnerable = true if start.is_a?(Pawn) && start.coordinate_difference(start.location, coordinates[2..3]) == [2, 0]
    if en_passant?(start, coordinates) && start.legal_en_passant?(coordinates, self)
      perform_en_passant(start, coordinates)
      update_piece_location(coordinates)
    else
      @cells[coordinates[2]][coordinates[3]] = @cells[coordinates[0]][coordinates[1]]
      @cells[coordinates[0]][coordinates[1]] = '   '
      update_piece_location(coordinates)
    end
  end

  def en_passant?(start, coordinates)
    start.is_a?(Pawn) &&
      [[1, 1], [1, -1]].include?(start.coordinate_difference(start.location, coordinates[2..3])) &&
      start.adjacent_cells_vulnerable?(self)
  end

  def perform_en_passant(start, coordinates)
    @cells[coordinates[2]][coordinates[3]] = @cells[coordinates[0]][coordinates[1]]
    @cells[coordinates[0]][coordinates[1]] = '   '
    if start.color == 'white'
      @cells[coordinates[2] + 1][coordinates[3]] = '   '
    elsif start.color == 'black'
      @cells[coordinates[2] - 1][coordinates[3]] = '   '
    end
  end

  def reset_vulnerability(current_player)
    if current_player.color == 'white'
      cells[3].each do |cell|
        reset_cell(cell)
      end
    else
      cells[4].each do |cell|
        reset_cell(cell)
      end
    end
  end

  def reset_cell(cell)
    cell.vulnerable = false if cell.is_a?(Pawn)
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
