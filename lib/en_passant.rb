# frozen_string_literal: true

# module containing the en passant logic and validation
module EnPassant
  def adjacent_cells_vulnerable?(board)
    left_cell = board.cells[location.first][location.last - 1]
    right_cell = board.cells[location.first][location.last + 1]
    return false unless left_cell.is_a?(Pawn) || right_cell.is_a?(Pawn)

    left_cell.vulnerable || right_cell.vulnerable
  end
end
