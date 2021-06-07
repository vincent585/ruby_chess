# frozen_string_literal: true

# module handling the logic of the Castling move
module Castling
  def perform_castling(castling_side)
    if white_kingside?(castling_side)
      move_pieces(castling_pieces[:white_kingside])
    elsif white_queenside?(castling_side)
      move_pieces(castling_pieces[:white_queenside])
    elsif black_kingside?(castling_side)
      move_pieces(castling_pieces[:black_kingside])
    else
      move_pieces(castling_pieces[:black_queenside])
    end
  end

  def move_pieces(pieces_to_castle)
    # TODO
  end

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
    return false if queenside_blocked?(king)

    (1..2).each do |col|
      tile_to_test = [king.location.first, king.location.last - col]
      return false if castling_tile_compromised?(tile_to_test)
    end
    true
  end

  def queenside_blocked?(king)
    (1..3).each do |col|
      tile_to_test = [king.location.first, king.location.last - col]
      return true unless tile_to_test == '   '
    end
    false
  end

  private

  def white_kingside?(castling_side)
    castling_side == 'O-O' && current_player.color == 'white'
  end

  def white_queenside?(castling_side)
    castling_side == 'O-O-O' && current_player.color == 'white'
  end

  def black_kingside?(castling_side)
    castling_side == 'O-O' && current_player.color == 'black'
  end

  def castling_pieces
    {
      white_kingside: [board.cells[7][4], board.cells[7][7]],
      white_queenside: [board.cells[7][4], board.cells[7][0]],
      black_kingside: [board.cells[0][4], board.cells[0][7]],
      black_queenside: [board.cells[0][4], board.cells[0][0]]
    }
  end
end
