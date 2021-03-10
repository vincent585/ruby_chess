# frozen_string_literal: true

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
  end
end
