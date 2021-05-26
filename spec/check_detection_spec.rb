# frozen_string_literal: true

require './lib/game'

describe CheckDetection do
  let(:dummy_game) { Game.new }
  let(:player_one) { Player.new(1, 'white') }
  let(:player_two) { Player.new(2, 'black') }

  before do
    dummy_game.set_board
    dummy_game.instance_variable_set(:@players, [player_one, player_two])
    dummy_game.instance_variable_set(:@current_player, player_one)
  end
end
