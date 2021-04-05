# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require './lib/board'

describe BoardValidation do
  let(:dummy_board) { Board.new }
  let(:dummy_player) { Player.new(1, 'black') }

  describe '#valid_pawn_move?' do
    before { dummy_board.cells[1][0] = Pawn.new("\u2659", 'black') }
    let(:pawn) { dummy_board.cells[1][0] }

    context 'when the move is forward one space, unblocked' do
      it 'is a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [2, 0], pawn, dummy_player)
        expect(result).to be true
      end
    end

    context 'when the move is forward two spaces, unblocked' do
      it 'is a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [3, 0], pawn, dummy_player)
        expect(result).to be true
      end
    end

    context 'when the move is diagonal one space, and there is an enemy piece there' do
      before { dummy_board.cells[2][1] = Pawn.new("\u2659", 'white') }
      it 'is a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [2, 1], pawn, dummy_player)
        expect(result).to be true
      end
    end

    context 'when the move is diagonal one space, but no enemy piece is there' do
      it 'is not a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [2, 1], pawn, dummy_player)
        expect(result).to be false
      end
    end

    context 'when the move is backward one space' do
      it 'is not a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [0, 0], pawn, dummy_player)
        expect(result).to be false
      end
    end

    context 'when the move is forward two spaces but the path is blocked' do
      before { dummy_board.cells[2][0] = Pawn.new("\u2659", 'black') }
      it 'is not a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [3, 0], pawn, dummy_player)
        expect(result).to be false
      end
    end

    context 'when the move is forward one space but the space is occupied' do
      before { dummy_board.cells[2][0] = Pawn.new("\u2659", 'white') }
      it 'is not a valid move' do
        result = dummy_board.valid_pawn_move?([1, 0], [2, 0], pawn, dummy_player)
        expect(result).to be false
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
