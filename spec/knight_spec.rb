# frozen_string_literal: true

require './lib/pieces/knight'

describe Knight do
  subject(:knight) { described_class.new("\u2658", 'black') }

  describe '#valid_knight_move?' do
    context 'when the move is forward 2, over 1' do
      before do
        valid_move = [2, 1]
        allow(knight).to receive(:coordinate_difference).and_return(valid_move)
      end

      it 'is a valid move' do
        result = knight.valid_knight_move?([0, 6], [2, 7])
        expect(result).to be true
      end
    end
  end
end
