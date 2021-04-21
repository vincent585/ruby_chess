# frozen_string_literal: true

# module for detecting check and checkmate
module CheckDetection
  def check?(king)
    # king = locate_king
    active_pieces.each do |piece|
      next if piece.color == current_player.color
      return true if piece.moves.include?(king)
    end
    false
  end

  def checkmate?
    king = locate_king
    if check?(king)
      king.find_king_moves
      true if king.moves.all? { |move| check?(move) }
    else
      false
    end
  end

  def generate_piece_moves
    board.cells.each do |row|
      row.each do |cell|
        cell.generate_moves(board, current_player) unless cell == '   ' || cell.color != current_player.color
        active_pieces << cell unless cell == '   '
      end
    end
  end

  def locate_king
    active_pieces.each do |piece|
      return piece if piece.is_a?(King) && piece.color == current_player.color
    end
  end

  def find_king_moves
    king.generate_moves(board, current_player)
  end
end
