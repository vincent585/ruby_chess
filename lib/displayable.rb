# frozen_string_literal: true

require 'rainbow'

# Module containing all display related methods
module Displayable
  def show_board
    print_column_letters
    cells.each_with_index do |row, i|
      print_row_number(i)
      print_rows(row, i)
      print_row_number(i)
      puts
    end
    print_column_letters
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

  def player_turn_prompt
    puts "#{current_player.color.capitalize}'s move!"
  end

  def player_color_prompt
    puts 'Player 1, choose a set of pieces by entering "white" or "black"'
  end

  def prompt_for_start
    puts 'Please enter a starting coordinate (e.g. "a2")'
  end

  def prompt_for_target
    puts 'Please enter a target coordinate (e.g. "a4")'
  end

  def print_column_letters
    puts '  a  b  c  d  e  f  g  h'
  end

  def game_over
    puts "Game over. Better luck next time, Player #{current_player.number}."
  end
end
