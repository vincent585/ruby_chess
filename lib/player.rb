# frozen_string_literal: true

# Player object
class Player
  attr_reader :number, :color

  def initialize(number, color)
    @number = number
    @color = color
  end
end
