# frozen_string_literal: true

# Board validation methods
module BoardValidation
  def path_clear?(start, target, piece)
    return true if piece.is_a?(Knight)

    start_row = start.first
    start_colummn = start.last
    target_row = target.first
    target_column = target.last

    return clear_row?(start, target) if start_row == target_row

    return clear_column?(start, target) if start_colummn == target_column

    return false unless clear_diagonal?(start, target)

    true
  end

  def clear_row?(start, target)
    direction = target.last > start.last ? 1 : -1
    len = (target.last - start.last).abs
    (1...len).each do |idx|
      return false if @cells[start.first][start.last + (idx * direction)] != '   '
    end
    true
  end

  def clear_column?(start, target)
    direction = target.first > start.first ? 1 : -1
    len = (target.first - start.first).abs
    (1...len).each do |idx|
      return false if @cells[start.first + (idx * direction)][start.last] != '   '
    end
    true
  end

  def clear_diagonal?(start, target)
    row_direction = target.first > start.first ? 1 : -1
    col_direction = target.last > start.last ? 1 : -1
    len = (target.first - start.first).abs
    (1...len).each do |i|
      return false if next_diagonal_square(start, i, row_direction, col_direction) != '   '
    end
  end

  def next_diagonal_square(start, idx, row_direction, col_direction)
    @cells[start.first + (idx * row_direction)][start.last + (idx * col_direction)]
  end

  def different_cell?(coordinates)
    coordinates[0..1] != coordinates[2..3]
  end

  def piece_selected?(coordinates, current_player)
    start = @cells[coordinates[0]][coordinates[1]]
    start != '   ' && start.color == current_player.color
  end

  def on_the_board?(coordinates)
    coordinates.all? { |coordinate| coordinate.between?(0, 7) }
  end

  def cell_not_occupied?(coordinates, current_player)
    @cells[coordinates[2]][coordinates[3]] == '   ' || not_friendly_piece?(coordinates, current_player)
  end

  def not_friendly_piece?(coordinates, current_player)
    @cells[coordinates[2]][coordinates[3]].color != current_player.color
  end

  def valid_pawn_move?(start, target, pawn, current_player)
    move = pawn.coordinate_difference(start, target)
    return false unless pawn.vald_move?(start, target)

    forward_moves = [[1, 0], [2, 0]]
    diagonal_moves = [[1, 1], 1, -1]
    return legal_pawn_forward?(start, target) if forward_moves.include?(move)
    return legal_pawn_diagonal?(target, current_player) if diagonal_moves.include?(move)
  end

  def legal_pawn_forward?(start, target)
    @cells[target.first][target.last] == '   ' && clear_column?(start, target)
  end

  def legal_pawn_diagonal?(target, current_player)
    @cells[target.first][target.last].color != current_player.color
  end
end
