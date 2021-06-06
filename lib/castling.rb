# frozen_string_literal: true

# module handling the logic of the Castling move
module Castling
  def can_castle?(king, rook)
    player_not_in_check?(king) &&
      castling_pieces_moved?(king, rook)
    # possibly game.board.row_clear? here once coordinate input is written
  end

  def castling_pieces_moved?(king, rook)
    rook.moved || king.moved
  end
end
