# frozen_string_literal: true

# module containing the en passant logic and validation
module EnPassant
  def adjacent_cells_vulnerable?(board)
    left_cell = board.cells[location.first][location.last - 1]
    right_cell = board.cells[location.first][location.last + 1]
    return false unless left_cell.is_a?(Pawn) || right_cell.is_a?(Pawn)

    left_cell.vulnerable || right_cell.vulnerable
  end

  def reset_vulnerability(board, current_player)
    if current_player.color == 'white'
      board.cells[3].each do |cell|
        reset_cell(cell)
      end
    else
      board.cells[4].each do |cell|
        reset_cell(cell)
      end
    end
  end

  def reset_cell(cell)
    cell.vulnerable = false if cell.is_a?(Pawn) && cell.vulnerable
  end
end
