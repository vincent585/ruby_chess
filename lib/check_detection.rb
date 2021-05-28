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
    king = locate_king
    if double_check?(king.location)
      return true unless king_move_available?(king)
    elsif single_check?(king.location)
      return true unless king_move_available?(king) || blocking_move?(king)
    end
    false
  end

  def generate_piece_moves(board = @board)
    find_active_pieces(board)
    active_pieces.each { |piece| piece.generate_moves(board) }
  end

  def find_attacking_pieces(king)
    @can_attack_king = []
    active_pieces.each do |piece|
      next if piece.color == current_player.color

      can_attack_king << piece if piece.moves.include?(king)
    end
  end

  def find_active_pieces(board = @board)
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
    return false if king.moves.all? { |move| can_attack_king.any? { |piece| piece.moves.include?(move) } }

    true
  end

  def blocking_move?(king)
    active_pieces.each do |piece|
      next unless piece.color == current_player.color
      return true if can_capture?(piece) || can_block?(king, piece)
    end
    false
  end

  def can_block?(king, piece, attacking = @can_attack_king.first)
    path = path_to_king(attacking, king)
    path.any? { |square| piece.moves.include?(square) }
  end

  def can_capture?(piece)
    piece.moves.include?(can_attack_king.first.location)
  end

  def path_to_king(attacking_piece, king)
    start_row = attacking_piece.location.first
    start_col = attacking_piece.location.last
    target_row = king.location.first
    target_col = king.location.last

    return row_path([start_row, start_col], [target_row, target_col]) if start_row == target_row
    return col_path([start_row, start_col], [target_row, target_col]) if start_col == target_col

    diagonal_path([start_row, start_col], [target_row, target_col])
  end

  def row_path(start, target, path = [])
    direction = target.last > start.last ? 1 : -1
    len = (target.last - start.last).abs
    (1...len).each do |idx|
      path << [start.first, start.last + (idx * direction)]
    end
    path
  end

  def col_path(start, target, path = [])
    direction = target.first > start.first ? 1 : -1
    len = (target.first - start.first).abs
    (1...len).each do |idx|
      path << [start.first + (idx * direction), start.last]
    end
    path
  end

  def diagonal_path(start, target, path = [])
    row_direction = target.first > start.first ? 1 : -1
    col_direction = target.last > start.last ? 1 : -1
    len = (target.first - start.first).abs
    (1...len).each do |i|
      path << next_diagonal_square(start, i, row_direction, col_direction)
    end
  end

  def next_diagonal_square(start, idx, row_direction, col_direction)
    [start.first + (idx * row_direction), start.last + (idx * col_direction)]
  end
end
