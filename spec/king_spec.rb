# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/pieces/king'

describe King do
  subject(:king) { described_class.new("\u2654", 'black') }

  describe '#valid_move?' do
    context 'when the move is forward one space' do
      it 'is a valid move' do
        result = king.valid_move?([7, 4], [6, 4])
        expect(result).to be true
      end
    end

    context 'when the move is backward one space' do
      it 'is a valid move' do
        result = king.valid_move?([6, 4], [7, 4])
        expect(result).to be true
      end
    end

    context 'when the move is horizontal one space' do
      it 'is a valid move' do
        result = king.valid_move?([7, 4], [7, 3])
        expect(result).to be true
      end
    end

    context 'when the move is diagonal one space' do
      it 'is a valid move' do
        result = king.valid_move?([7, 4], [6, 5])
        expect(result).to be true
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
