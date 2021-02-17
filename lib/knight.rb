# frozen_string_literal: true

# Knight piece object
class Knight
  attr_reader :marker, :color

  def initialize(marker, color)
    # use "\u2658" for black, "\u265E" for white to display properly in terminal.
    @marker = marker
    @color = color
  end
end
