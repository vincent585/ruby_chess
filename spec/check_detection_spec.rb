# frozen_string_literal: true

require './lib/game'

# rubocop:disable Metrics/BlockLength

describe CheckDetection do
  let(:dummy_game) { Game.new }
  let(:player_one) { Player.new(1, 'white') }
  let(:player_two) { Player.new(2, 'black') }

  before do
    dummy_game.set_board
    dummy_game.instance_variable_set(:@players, [player_one, player_two])
    dummy_game.instance_variable_set(:@current_player, player_one)
  end

  describe '#find_active_pieces' do
    context 'when all the pieces remain' do
      it 'adds all 32 pieces to the active pieces' do
        dummy_game.find_active_pieces
        expect(dummy_game.active_pieces.length).to eq(32)
      end
    end

    context 'when a piece is removed' do
      before do
        dummy_game.board.cells[7][4] = '   '
      end
      it 'the size of active pieces decreases by one' do
        dummy_game.find_active_pieces
        expect(dummy_game.active_pieces.length).to eq(31)
      end
    end
  end

  describe '#find_attacking_pieces' do
    # edit board cells to reflect attacking positions/non-attacking for each example
    # TODO
  end
end

# rubocop:enable Metrics/BlockLength
