# frozen_string_literal: true

require './lib/board'

# rubocop:disable Metrics/BlockLength

describe Board do
  subject(:board) { described_class.new }
  let(:player) { Player.new(1, 'white') }

  before do
    board.set_black_first_row
    board.set_black_pawns
    board.set_white_pawns
    board.set_white_first_row
  end

  describe '#valid_coordinates?' do
    context 'when the coordinates are not on the board' do
      it 'is not valid coordinates' do
        result = board.valid_coordinates?([7, 1, 8, 1], player)
        expect(result).to be false
      end
    end

    context 'when the coordinates are on the board' do
      it 'is valid coordinates' do
        result = board.valid_coordinates?([7, 1, 5, 0], player)
        expect(result).to be true
      end
    end

    context 'when the start and end coordinates are the same' do
      it 'is not valid coordinates' do
        result = board.valid_coordinates?([7, 1, 7, 1], player)
        expect(result).to be false
      end
    end

    context 'when the start and end coordinates are different' do
      it 'is valid coordinates' do
        result = board.valid_coordinates?([7, 1, 5, 0], player)
        expect(result).to be true
      end
    end

    context 'when the piece selected is not the current player color' do
      it 'is not valid coordinates' do
        result = board.valid_coordinates?([0, 1, 2, 0], player)
        expect(result).to be false
      end
    end

    context 'when the piece selected is the current player color' do
      it 'is valid coordinates' do
        result = board.valid_coordinates?([7, 1, 5, 2], player)
        expect(result).to be true
      end
    end

    context 'when the starting cell is an empty cell' do
      it 'is not valid coordinates' do
        result = board.valid_coordinates?([5, 0, 4, 0], player)
        expect(result).to be false
      end
    end

    context 'when the target cell is occupied' do
      it 'is not valid coordinates' do
        result = board.valid_coordinates?([7, 1, 6, 3], player)
        expect(result). to be false
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
