# frozen_string_literal: true

require './lib/moveable'

# Piece super class for all pieces
class Piece
  include Moveable
  attr_reader :marker, :color

  def initialize(marker, color)
    @marker = marker
    @color = color
  end

  def to_s
    " #{marker} "
  end
end
