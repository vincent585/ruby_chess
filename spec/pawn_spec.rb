# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/pieces/pawn'
require './lib/board'
require './lib/player'

describe Pawn do
  subject(:pawn) { described_class.new("\u2659", 'black', [1, 0]) }
  let(:dummy_board) { Board.new }
  let(:dummy_player) { Player.new(1, 'black') }

  describe '#valid_move?' do
    context 'when the move is one space forward' do
      it 'is a valid move' do
        result = pawn.valid_move?([1, 0], [2, 0], dummy_board, dummy_player)
        expect(result).to be true
      end
    end

    context 'when the move is two spaces forward and the pawn has not been moved' do
      it 'is a valid move' do
        result = pawn.valid_move?([1, 0], [3, 0], dummy_board, dummy_player)
        expect(result).to be true
      end
    end

    context 'when the move is diagonal one space' do
      before { dummy_board.cells[2][1] = Pawn.new("\u2659", 'white', [2, 1]) }
      it 'is a valid move' do
        result = pawn.valid_move?([1, 0], [2, 1], dummy_board, dummy_player)
        expect(result).to be true
      end
    end

    context 'when the move is forward two spaces but the pawn has been moved' do
      it 'is not a valid move' do
        pawn.instance_variable_set(:@moved, true)
        result = pawn.valid_move?([3, 0], [5, 0], dummy_board, dummy_player)
        expect(result).to be false
      end
    end

    context 'when the move is backwards' do
      it 'is not a valid move' do
        result = pawn.valid_move?([3, 0], [2, 0], dummy_board, dummy_player)
        expect(result).to be false
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
