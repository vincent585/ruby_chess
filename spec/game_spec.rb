# frozen_string_literal: true

require './lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:player_one) { Player.new(1, 'white') }
  let(:player_two) { Player.new(2, 'black') }

  describe '#set_board' do
    before do
      game.set_board
    end

    it 'sets the black first row' do
      expect(game.board.cells[0]).not_to include('   ')
    end

    it 'sets the black second row' do
      expect(game.board.cells[1]).to all(be_a(Pawn))
    end

    it 'sets the white first row' do
      expect(game.board.cells[7]).not_to include('   ')
    end

    it 'sets the white second row' do
      expect(game.board.cells[6]).to all(be_a(Pawn))
    end
  end
end
