# frozen_string_literal: true

require 'rainbow'

# Module containing all display related methods
module Displayable
  def show_board
    cells.each_with_index do |row, i|
      print_row(row, i)
      puts
    end
  end

  def print_row(row, index)
    row.each_with_index do |cell, j|
      if index.even?
        print Rainbow(cell).bg(:white) if j.even?
        print Rainbow(cell).bg(:black) if j.odd?
      else
        print Rainbow(cell).bg(:white) if j.odd?
        print Rainbow(cell).bg(:black) if j.even?
      end
    end
  end
end
