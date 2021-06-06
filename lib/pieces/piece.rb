# frozen_string_literal: true

require './lib/moveable'

# Piece super class for all pieces
class Piece
  include Moveable
  attr_reader :marker, :color
  attr_accessor :location, :moves, :moved

  def initialize(marker, color, location = nil, moved = false)
    @marker = marker
    @color = color
    @location = location
    @moved = moved
    @moves = []
  end

  def to_s
    " #{marker} "
  end
end
