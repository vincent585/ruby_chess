# frozen_string_literal: true

# module for detecting check and checkmate
module CheckDetection
  def double_check?(king)
    find_attacking_pieces(king)
    return false if can_attack_king.length <= 1

    true
  end

  def single_check?(king)
    active_pieces.each do |piece|
      next if piece.color == current_player.color
      return true if piece.moves.include?(king)
    end
    false
  end

  def checkmate?
    return false if active_pieces.empty?

    king = locate_king
    if double_check?(king.location)
      king_move_available?(king)
    elsif single_check?(king.location)
      king_move_available?(king) || blocking_move?
    else
      false
    end
  end

  def generate_piece_moves
    find_active_pieces
    active_pieces.each { |piece| piece.generate_moves(board, current_player) }
  end

  def find_attacking_pieces(king)
    @can_attack_king = []
    active_pieces.each do |piece|
      next if piece.color == current_player.color

      can_attack_king << piece if piece.moves.include?(king)
    end
  end

  def find_active_pieces
    @active_pieces = []
    board.cells.each do |row|
      row.each do |cell|
        active_pieces << cell unless cell == '   '
      end
    end
  end

  def locate_king
    active_pieces.each do |piece|
      return piece if piece.is_a?(King) && piece.color == current_player.color
    end
  end

  def king_move_available?(king)
    king.generate_moves(board, current_player)
    king.moves.all? { |move| single_check?(move) }
  end

  def blocking_move?
    # TODO
  end
end
