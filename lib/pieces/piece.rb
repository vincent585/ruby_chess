# frozen_string_literal: true

require './lib/moveable'

# Piece super class for all pieces
class Piece
  include Moveable
  attr_reader :marker, :color
  attr_accessor :location, :captures

  def initialize(marker, color, location = nil)
    @marker = marker
    @color = color
    @location = location
    @captures = []
  end

  def to_s
    " #{marker} "
  end
end
