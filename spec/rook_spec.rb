# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/pieces/rook'

describe Rook do
  subject(:rook) { described_class.new("\u2656", 'black') }

  describe '#valid_move?' do
    context 'when the move is 3 spaces forward' do
      it 'is a valid move' do
        result = rook.valid_move?([7, 0], [4, 0])
        expect(result).to be true
      end
    end

    context 'when the move is left 2 spaces' do
      it 'is a valid move' do
        result = rook.valid_move?([7, 4], [7, 2])
        expect(result).to be true
      end
    end

    context 'when the move is back 5 spaces' do
      it 'is a valid move' do
        result = rook.valid_move?([1, 6], [6, 6])
        expect(result).to be true
      end
    end

    context 'when the move is right 4 spaces' do
      it 'is a valid move' do
        result = rook.valid_move?([3, 2], [3, 6])
        expect(result).to be true
      end
    end

    context 'when the move is diagonal' do
      it 'is not a valid move' do
        result = rook.valid_move?([3, 2], [4, 3])
        expect(result).to be false
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
