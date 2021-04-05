# frozen_string_literal: true

require './lib/board'

describe BoardValidation do
  let(:dummy_board) { Board.new }
  let(:dummy_player) { Player.new(1, 'black') }

  describe '#valid_pawn_move?' do
    context 'when the move is forward one space, unblocked' do
      before do
        dummy_board.cells[1][0] = Pawn.new("\u2659", 'black')
      end
      it 'is a valid move' do
        pawn = dummy_board.cells[1][0]
        result = dummy_board.valid_pawn_move?([1, 0], [2, 0], pawn, dummy_player)
        expect(result).to be true
      end
    end
  end
end
