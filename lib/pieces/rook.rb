# frozen_string_literal: true

require_relative 'piece'

# Rook piece object
class Rook < Piece
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2656" for black, "\u265C" for white
    super(marker, color)
  end
end
