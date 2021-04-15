# frozen_string_literal: true

# module for detecting check and checkmate
module CheckDetection
  def check?
    # TODO
  end

  def generate_piece_moves
    board.cells.each do |row|
      row.each do |cell|
        cell.generate_moves(board, current_player) if cell != '   '
      end
    end
  end
end
