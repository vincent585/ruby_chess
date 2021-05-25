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
        expect(game.players.first.color).to eq('white')
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

  describe '#player_turns' do
    before do
      game.instance_variable_set(:@players, [player_one, player_two])
      game.instance_variable_set(:@current_player, game.players.first)
    end

    context 'when it is checkmate' do
      before do
        allow(game).to receive(:generate_piece_moves)
        allow(game.board).to receive(:show_board)
        allow(game).to receive(:checkmate?).and_return(true)
      end

      it 'ends the loop and displays game over message' do
        expect(game).to receive(:game_over)
        game.player_turns
      end
    end

    context 'when it is not checkmate, then is' do
      before do
        allow(game).to receive(:generate_piece_moves).at_least(:twice)
        allow(game.board).to receive(:show_board)
        allow(game).to receive(:checkmate?).and_return(false, true)
      end

      it 'runs player_turn once and ends the game' do
        expect(game).to receive(:player_turn).once
        expect(game).to receive(:game_over).once
        game.player_turns
      end

      it 'updates the current player to player 2' do
        allow(game).to receive(:player_turn)
        allow(game).to receive(:game_over)
        expect(game.current_player.color).to eq('white')
        game.player_turns
        expect(game.current_player.color).to eq('black')
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
