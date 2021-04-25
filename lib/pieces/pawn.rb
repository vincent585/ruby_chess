# frozen_string_literal: true

require_relative 'piece'

# Pawn piece object
class Pawn < Piece
  attr_accessor :moved

  def initialize(marker, color, location)
    # use "\u2659" for black, "\u265F" for white
    super(marker, color, location)
    @moved = false
  end

  def valid_move?(start, target, board)
    move = coordinate_difference(start, target)
    return false if move == [2, 0] && @moved == true

    forward_moves = [[1, 0], [2, 0]]
    diagonal_moves = [[1, 1], [1, -1]]
    return legal_pawn_forward?(start, target, board) if forward_moves.include?(move)
    return legal_pawn_diagonal?(target, board) if diagonal_moves.include?(move)

    false
  end

  def generate_moves(board, move_set = [])
    board.cells.each_with_index do |row, i|
      row.each_with_index do |_cell, j|
        move = [i, j]
        move_set << move if board.cell_not_occupied?(location, move) &&
                            valid_move?(location, move, board) &&
                            board.path_clear?(location, move, self)
      end
    end
    @moves = move_set
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
