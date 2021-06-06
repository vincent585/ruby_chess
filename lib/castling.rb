# frozen_string_literal: true

# module handling the logic of the Castling move
module Castling
  def can_castle?(king, rook, castling_side)
    player_not_in_check?(king) &&
      castling_pieces_moved?(king, rook) &&
      safe_passage?(king, castling_side)
  end

  def castling_pieces_moved?(king, rook)
    rook.moved || king.moved
  end

  def safe_passage?(king, castling_side)
    return kingside_available?(king) if castling_side == 'O-O'

    queenside_available?(king)
  end

  def castling_tile_compromised?(location)
    return true if enemy_pieces.any? { |piece| piece.moves.include?(location) }
  end

  private

  def enemy_pieces
    enemy_pieces = []
    active_pieces.each do |piece|
      next if piece.color == current_player.color

      enemy_pieces << piece
    end
    enemy_pieces
  end

  def kingside_available?(king)
    (1..2).each do |col|
      tile_to_test = [king.location.first, king.location.last + col]
      return false if castling_tile_compromised?(tile_to_test) || tile_to_test != '   '
    end
    true
  end

  def queenside_available?(king)
    2.downto(1) do |col|
      tile_to_test = [king.location.first, king.location.last - col]
      return false if castling_tile_compromised?(tile_to_test) || tile_to_test != '   '
    end
    true
  end
end
