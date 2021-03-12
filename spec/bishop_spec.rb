# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/pieces/bishop'

describe Bishop do
  subject(:bishop) { described_class.new("\u2657", 'black') }

  describe '#valid_move?' do
    context 'when the move is diagonal forward-right two squares' do
      it 'is a valid move' do
        result = bishop.valid_move?([7, 2], [5, 4])
        expect(result).to be true
      end
    end

    context 'when the move is diagonal back-left two squares' do
      it 'is a valid move' do
        result = bishop.valid_move?([3, 6], [5, 4])
        expect(result).to be true
      end
    end

    context 'when the move is diagonal forward-left two squares' do
      it 'is a valid move' do
        result = bishop.valid_move?([7, 2], [5, 0])
        expect(result).to be true
      end
    end

    context 'when the move is diagonal back-right 3 squares' do
      it 'is a valid move' do
        result = bishop.valid_move?([3, 0], [6, 3])
        expect(result).to be true
      end
    end

    context 'when the move is straight forward two spaces' do
      it 'is not a valid move' do
        result = bishop.valid_move?([7, 2], [5, 2])
        expect(result).to be false
      end
    end

    context 'when the move is left 4 spaces' do
      it 'is not a valid move' do
        result = bishop.valid_move?([3, 7], [3, 3])
        expect(result).to be false
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
