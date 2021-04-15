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

  def valid_move?(start, target, board, current_player)
    move = coordinate_difference(start, target)
    return false if move == [2, 0] && @moved == true

    forward_moves = [[1, 0], [2, 0]]
    diagonal_moves = [[1, 1], [1, -1]]
    return legal_pawn_forward?(start, target, board) if forward_moves.include?(move)
    return legal_pawn_diagonal?(target, current_player, board) if diagonal_moves.include?(move)

    false
  end

  def generate_moves(board, current_player, moves = @moves)
    board.cells.each_with_index do |row, i|
      row.each_with_index do |_cell, j|
        move = [i, j]
        moves << move if board.cell_not_occupied?(move, current_player) &&
                         valid_move?(location, move, board, current_player) &&
                         board.path_clear?(location, move, self)
      end
    end
    moves
  end

  private

  def legal_pawn_forward?(start, target, board)
    board.cells[target.first][target.last] == '   ' && board.clear_column?(start, target)
  end

  def legal_pawn_diagonal?(target, current_player, board)
    board.cells[target.first][target.last] != '   ' &&
      board.cells[target.first][target.last].color != current_player.color
  end

  def move_set
    [[1, 0], [2, 0], [1, 1], [1, -1]].freeze
  end
end
