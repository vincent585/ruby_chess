# frozen_string_literal: true

require './lib/pieces/knight'

describe Knight do
  subject(:knight) { described_class.new("\u2658", 'black') }

  describe '#valid_knight_move?' do
    context 'when the move is forward 2, over 1' do
      it 'is a valid move' do
        result = knight.valid_knight_move?([0, 6], [2, 7])
        expect(result).to be true
      end
    end

    context 'when the move is backwards 2, over 1' do
      it 'is a valid move' do
        result = knight.valid_knight_move?([2, 7], [0, 6])
        expect(result).to be true
      end
    end

    context 'when the move is invalid' do
      it 'in not a valid move' do
        result = knight.valid_knight_move?([0, 6], [3, 7])
        expect(result).to be false
      end
    end
  end
end
