# frozen_string_literal: true

describe Game do
  subject(:game) { described_class.new }
  let(:player_one) { Player.new(1, 'white') }
  let(:player_two) { Player.new(2, 'black') }

  before do
    game.set_board
    game.set_players
    game.set_current_player
  end

  # TODO
end
