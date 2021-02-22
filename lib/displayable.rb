# frozen_string_literal: true

require 'rainbow'

# Module containing all display related methods
module Displayable
  def show_board
    print_column_letters
    cells.each_with_index do |row, i|
      print_row_number(i)
      print_rows(row, i)
      puts
    end
  end

  def print_rows(row, index)
    row.each_with_index do |cell, j|
      index.even? ? even_row(cell, j) : odd_row(cell, j)
    end
  end

  def even_row(cell, index)
    print Rainbow(cell).bg(:white) if index.even?
    print Rainbow(cell).bg(:magenta) if index.odd?
  end

  def odd_row(cell, index)
    print Rainbow(cell).bg(:white) if index.odd?
    print Rainbow(cell).bg(:magenta) if index.even?
  end

  def print_row_number(index)
    print index + 1
  end

  def print_column_letters
    puts '  A  B  C  D  E  F  G  H'
  end
end
