# frozen_string_literal: true

require './lib/board'

# rubocop:disable Metrics/BlockLength

describe Board do
  subject(:board) { described_class.new }

  describe '#valid_coordinates?' do
    context 'when the coordinates are not on the board' do
      before do
        board.set_black_first_row
        board.set_black_pawns
        board.set_white_pawns
        board.set_white_first_row
      end

      it 'is not valid coordinates' do
        player = Player.new(1, 'white')
        result = board.valid_coordinates?([7, 1, 8, 1], player)
        expect(result).to be false
      end
    end

    context 'when the coordinates are on the board' do
      before do
        board.set_black_first_row
        board.set_black_pawns
        board.set_white_pawns
        board.set_white_first_row
      end

      it 'is valid coordinates' do
        player = Player.new(1, 'white')
        result = board.valid_coordinates?([7, 1, 5, 0], player)
        expect(result).to be true
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
