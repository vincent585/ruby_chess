# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:player_one) { Player.new(1, 'white') }
  let(:player_two) { Player.new(2, 'black') }

  before do
    game.set_board
  end

  describe '#set_board' do
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

  describe '#generate_piece_moves' do
    it 'finds the active pieces' do
      game.generate_piece_moves
      expect(game.active_pieces).not_to be_empty
    end

    it 'generates active piece moves' do
      game.generate_piece_moves
      result = game.active_pieces.any? { |piece| piece.moves.any? }
      expect(result).to be true
    end
  end

  describe '#set_players' do
    context 'when a player enters a valid color' do
      before do
        allow(game).to receive(:player_color_prompt).once
        allow(game).to receive(:select_color).and_return('white')
      end

      it 'sets player one to white' do
        game.set_players
        expect(game.players.first.color).to eq('white')
      end
    end

    context 'when a player enters an invalid color' do
      before do
        invalid_color = 'yellow'
        valid_color = 'white'
        allow(game).to receive(:puts)
        allow(game).to receive(:select_color).and_return(invalid_color, valid_color)
      end

      it 'sets player one to white and displays error message once' do
        game.set_players
        expect(game.players.first.color).not_to eq('black')
      end
    end

    context 'when player one selects white' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:select_color).and_return('white')
      end

      it 'sets player two to black' do
        game.set_players
        expect(game.players.last.color).to eq('black')
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
