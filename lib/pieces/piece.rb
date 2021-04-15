# frozen_string_literal: true

require './lib/moveable'

# Piece super class for all pieces
class Piece
  include Moveable
  attr_reader :marker, :color
  attr_accessor :location, :moves

  def initialize(marker, color, location = nil)
    @marker = marker
    @color = color
    @location = location
    @moves = []
  end

  def to_s
    " #{marker} "
  end
end
