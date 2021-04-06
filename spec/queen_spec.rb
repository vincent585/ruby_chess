# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/pieces/queen'

describe Queen do
  subject(:queen) { described_class.new("\u2655", 'black') }

  describe '#valid_move?' do
    context 'when the move is forward 5 spaces' do
      it 'is a valid move' do
        result = queen.valid_move?([0, 5], [5, 5])
        expect(result).to be true
      end
    end

    context 'when the move is backward 3 spaces' do
      it 'is a valid move' do
        result = queen.valid_move?([5, 5], [2, 5])
        expect(result).to be true
      end
    end

    context 'when the move is horizontal-left 2 spaces' do
      it 'is a valid move' do
        result = queen.valid_move?([2, 2], [2, 0])
        expect(result).to be true
      end
    end

    context 'when the move is diagonal 4 spaces' do
      it 'is a valid move' do
        result = queen.valid_move?([2, 2], [6, 6])
        expect(result).to be true
      end
    end

    context 'when the move is forward one space, right two spaces' do
      it 'is not a valid move' do
        result = queen.valid_move?([0, 5], [1, 7])
        expect(result).to be false
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
