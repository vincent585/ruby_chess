# frozen_string_literal: true

# module for detecting check and checkmate
module CheckDetection
  def check?
    king_location = locate_king
    active_pieces.each do |piece|
      next if piece.color == current_player.color
      return true if piece.moves.include?(king_location)
    end
    false
  end

  def generate_piece_moves
    board.cells.each do |row|
      row.each do |cell|
        cell.generate_moves(board, current_player) unless cell == '   '
        active_pieces << cell unless cell == '   '
      end
    end
  end

  def locate_king
    active_pieces.each do |piece|
      return piece.location if piece.is_a?(King) && piece.color == current_player.color
    end
  end
end
