# frozen_string_literal: true

require_relative 'piece'

# Pawn piece object
class Pawn < Piece
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2659" for black, "\u265F" for white
    super(marker, color)
  end
end
