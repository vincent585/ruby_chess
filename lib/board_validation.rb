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
      return false if cells[start.first][start.last + (idx * direction)] != '   '
    end
    true
  end

  def clear_column?(start, target)
    direction = target.first > start.first ? 1 : -1
    len = (target.first - start.first).abs
    (1...len).each do |idx|
      return false if cells[start.first + (idx * direction)][start.last] != '   '
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
    cells[start.first + (idx * row_direction)][start.last + (idx * col_direction)]
  end

  def different_cell?(start, target)
    start != target
  end

  def piece_selected?(start, current_player)
    @cells[start.first][start.last] != '   ' && @cells[start.first][start.last].color == current_player.color
  end

  def cell_not_occupied?(start, target)
    @cells[target.first][target.last] == '   ' || not_friendly_piece?(start, target)
  end

  def not_friendly_piece?(start, target)
    @cells[target.first][target.last].color != @cells[start.first][start.last].color
  end
end
