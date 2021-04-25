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
      king_move_available?(king) || blocking_move?(king)
    else
      false
    end
  end

  def generate_piece_moves
    find_active_pieces
    active_pieces.each { |piece| piece.generate_moves(board) }
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
    king.generate_moves(board)
    return false if king.moves.all? { |move| can_attack_king.each { |piece| piece.moves.include?(move) } }

    true
  end

  def blocking_move?(king)
    # check friendly piece moves. if the piece's move list includes the piece that is attacking the king, return true (can capture attacking piece)
    active_pieces.each do |piece|
      next unless piece.color == current_player.color

      return true if can_block?(piece) || can_capture?(piece)
    end
    # if the attacking piece cannot be captured, check to see if it can be blocked.
    # to do this, slice the array of attacking piece's moves from the current position up to but not including the king's position.
    # iterate over all friendly piece's moves. if any of the attacking piece's "path" is included in the friendly piece's moves, return true.
  end

  def can_block?(piece, attacking = @can_attack_king.first)
    puts 'hello from can_block'
  end

  def can_capture?(piece)
    piece.moves.include?(can_attack_king.first)
  end
end
