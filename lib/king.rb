# frozen_string_literal: true

# King piece object
class King
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2654" for black and "\u265A" for white
    @marker = marker
    @color = color
  end
end
