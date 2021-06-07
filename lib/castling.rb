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
    elsif black_queenside?(castling_side)
      move_pieces(castling_pieces[:black_queenside])
    end
  end

  def move_pieces(pieces_to_castle)
    king = pieces_to_castle.first
    rook = pieces_to_castle.last
    if rook.location.last == 7
      kingside_move(king, rook)
    elsif rook.location.last.zero?
      queenside_move(king, rook)
    end
  end

  def queenside_move(king, rook)
    rook.location[1] = 3
    board.cells[rook.location.first][rook.location.last] = rook
    board.cells[rook.location.first][0] = '   '
    king.location[1] = 2
    board.cells[king.location.first][king.location.last] = king
    board.cells[king.location.first][4] = '   '
    board
  end

  def kingside_move(king, rook)
    rook.location[1] = 5
    board.cells[rook.location.first][rook.location.last] = rook
    board.cells[rook.location.first][7] = '   '
    king.location[1] = 6
    board.cells[king.location.first][king.location.last] = king
    board.cells[king.location.first][4] = '   '
    board
  end

  def can_castle?(castling_side)
    pieces = select_castling_pieces(castling_side)
    king = pieces.first
    rook = pieces.last
    player_not_in_check?(king) &&
      castling_pieces_unmoved?(king, rook) &&
      safe_passage?(king, castling_side)
  end

  def select_castling_pieces(castling_side)
    if white_kingside?(castling_side)
      castling_pieces[:white_kingside]
    elsif white_queenside?(castling_side)
      castling_pieces[:white_queenside]
    elsif black_kingside?(castling_side)
      castling_pieces[:black_kingside]
    elsif black_queenside?(castling_side)
      castling_pieces[:black_queenside]
    end
  end

  def castling_pieces_unmoved?(king, rook)
    true unless rook.moved || king.moved
  end

  def safe_passage?(king, castling_side)
    return kingside_available?(king) if castling_side == 'o-o'

    queenside_available?(king)
  end

  def castling_tile_compromised?(location)
    enemy_pieces = find_enemy_pieces
    return true if enemy_pieces.any? { |piece| piece.moves.include?(location) }

    false
  end

  def find_enemy_pieces
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
      return false if castling_tile_compromised?(tile_to_test) || !tile_empty?(tile_to_test)
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
      tile = [king.location.first, king.location.last - col]
      return true unless tile_empty?(tile)
    end
    false
  end

  def tile_empty?(tile)
    board.cells[tile.first][tile.last] == '   '
  end

  def white_kingside?(castling_side)
    castling_side == 'o-o' && current_player.color == 'white'
  end

  def white_queenside?(castling_side)
    castling_side == 'o-o-o' && current_player.color == 'white'
  end

  def black_kingside?(castling_side)
    castling_side == 'o-o' && current_player.color == 'black'
  end

  def black_queenside?(castling_side)
    castling_side == 'o-o-o' && current_player.color == 'black'
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
