# frozen_string_literal: true

require_relative 'displayable'

# Board class representing the Chess board
class Board
  include Displayable
  attr_reader :cells

  def initialize
    @cells = Array.new(8) { Array.new(8, '   ') }
  end
end

x = Board.new
x.show_board
