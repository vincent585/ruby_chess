# frozen_string_literal: true

require_relative 'piece'

# Pawn piece object
class Pawn < Piece
  attr_accessor :moved, :vulnerable

  def initialize(marker, color, location)
    # use "\u2659" for black, "\u265F" for white
    super(marker, color, location)
    @vulnerable = false
  end

  def valid_move?(start, target, board)
    pawn_move = coordinate_difference(start, target)
    return false unless move_set.include?(pawn_move)
    return false if pawn_move == [2, 0] && @moved == true

    forward_moves = [[1, 0], [2, 0]]
    diagonal_moves = [[1, 1], [1, -1]]
    return legal_pawn_forward?(start, target, board) if forward_moves.include?(pawn_move)
    return legal_pawn_diagonal?(target, board) if diagonal_moves.include?(pawn_move)

    false
  end

  def generate_moves(board, possible_moves = [])
    board.cells.each_with_index do |row, i|
      row.each_with_index do |_cell, j|
        move = [i, j]
        possible_moves << move if valid_move?(location, move, board)
      end
    end
    @moves = possible_moves
  end

  private

  def legal_pawn_forward?(start, target, board)
    board.cells[target.first][target.last] == '   ' && board.clear_column?(start, target)
  end

  def legal_pawn_diagonal?(target, board)
    board.cells[target.first][target.last] != '   ' &&
      board.cells[target.first][target.last].color != color
  end

  def move_set
    [[1, 0], [2, 0], [1, 1], [1, -1]].freeze
  end
end
