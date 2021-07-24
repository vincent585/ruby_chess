# frozen_string_literal: true

# module containing the en passant logic and validation
module EnPassant
  def legal_en_passant?(target, board)
    return true if board.cells[target[0]][target[1]] == '   ' &&
                   adjacent_cells_vulnerable?(board) &&
                   not_moving_away?(target, board)

    false
  end

  def not_moving_away?(target, board)
    p coordinate_difference(location, target)
    left_cell = board.cells[location.first][location.last - 1]
    right_cell = board.cells[location.first][location.last + 1]
    if left_cell.is_a?(Pawn) && left_cell.vulnerable && right_cell == '   '
      return false unless coordinate_difference(location, target) == [1, 1]
    elsif right_cell.is_a?(Pawn) && right_cell.vulnerable && left_cell == '   '
      return false unless coordinate_difference(location, target) == [1, -1]
    end
    true
  end

  def adjacent_cells_vulnerable?(board)
    left_cell = board.cells[location.first][location.last - 1]
    right_cell = board.cells[location.first][location.last + 1]
    return false unless (left_cell.is_a?(Pawn) && left_cell.color != color) || (right_cell.is_a?(Pawn) && right_cell.color != color)

    (left_cell.is_a?(Pawn) && left_cell.vulnerable) || (right_cell.is_a?(Pawn) && right_cell.vulnerable)
  end
end
