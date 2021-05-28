# frozen_string_literal: true

require './lib/game'

# rubocop:disable Metrics/BlockLength

describe CheckDetection do
  let(:dummy_game) { Game.new }
  let(:player_one) { Player.new(1, 'white') }
  let(:player_two) { Player.new(2, 'black') }

  before do
    dummy_game.set_board
    dummy_game.instance_variable_set(:@players, [player_one, player_two])
    dummy_game.instance_variable_set(:@current_player, player_two)
  end

  describe '#find_active_pieces' do
    context 'when all the pieces remain' do
      it 'adds all 32 pieces to the active pieces' do
        dummy_game.find_active_pieces
        expect(dummy_game.active_pieces.length).to eq(32)
      end
    end

    context 'when a piece is removed' do
      before do
        dummy_game.board.cells[7][4] = '   '
      end
      it 'the size of active pieces decreases by one' do
        dummy_game.find_active_pieces
        expect(dummy_game.active_pieces.length).to eq(31)
      end
    end
  end

  describe '#find_attacking_pieces' do
    let(:king) { King.new("\u2654", 'black', [0, 4]) }
    let(:queen) { Queen.new("\u265B", 'white', [7, 4]) }

    before do
      dummy_game.board.instance_variable_set(:@cells, positions)
      dummy_game.generate_piece_moves
    end

    context 'when the queen can attack the king' do
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   ']
        ]
      end

      it 'is present in pieces that can attack the king' do
        dummy_game.find_attacking_pieces(king.location)
        expect(dummy_game.can_attack_king.first).to eq(queen)
      end
    end

    context 'when two pieces can attack the king' do
      let(:rook) { Rook.new("\u265C", 'white', [0, 0]) }
      let(:positions) do
        [
          [rook, '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   ']
        ]
      end

      it 'adds two pieces to the pieces that can attack king' do
        dummy_game.find_attacking_pieces(king.location)
        expect(dummy_game.can_attack_king.length).to eq(2)
      end
    end

    context 'when no pieces can attack the king' do
      let(:rook) { Rook.new("\u265C", 'white', [1, 0]) }
      let(:queen) { Queen.new("\u265B", 'white', [7, 3]) }
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          [rook, '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', queen, '   ', '   ', '   ', '   ']
        ]
      end

      it 'does not add any pieces to the pieces that can attack king' do
        dummy_game.find_attacking_pieces(king.location)
        expect(dummy_game.can_attack_king).to be_empty
      end
    end
  end

  describe '#locate_king' do
    before do
      dummy_game.find_active_pieces
    end

    context 'when the current player is black' do
      it 'returns the black king' do
        result = dummy_game.locate_king
        expect(result.color).to eq('black')
      end
    end

    context 'when the current player is white' do
      before do
        dummy_game.find_active_pieces
        dummy_game.instance_variable_set(:@current_player, player_one)
      end

      it 'retuns the white king' do
        result = dummy_game.locate_king
        expect(result.color).to eq('white')
      end
    end
  end

  describe '#double_check?' do
    let(:king) { King.new("\u2654", 'black', [0, 4]) }
    let(:queen) { Queen.new("\u265B", 'white', [7, 4]) }

    context 'when there are two pieces that can attack the king' do
      let(:rook) { Rook.new("\u265C", 'white', [0, 0]) }
      let(:positions) do
        [
          [rook, '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   ']
        ]
      end

      before do
        dummy_game.board.instance_variable_set(:@cells, positions)
        allow(dummy_game).to receive(:find_attacking_pieces)
        dummy_game.instance_variable_set(:@can_attack_king, [queen, rook])
      end
      it 'is double check' do
        expect(dummy_game.double_check?(king.location)).to be true
      end
    end

    context 'when only one piece can attack the king' do
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   ']
        ]
      end

      before do
        dummy_game.board.instance_variable_set(:@cells, positions)
        allow(dummy_game).to receive(:find_attacking_pieces)
        dummy_game.instance_variable_set(:@can_attack_king, [queen])
      end

      it 'is not double check' do
        expect(dummy_game.double_check?(king.location)).to be false
      end
    end
  end

  describe '#single_check?' do
    let(:king) { King.new("\u2654", 'black', [0, 4]) }
    let(:queen) { Queen.new("\u265B", 'white', [7, 4]) }

    context 'when one piece can attack the king' do
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   ']
        ]
      end

      before do
        dummy_game.board.instance_variable_set(:@cells, positions)
        dummy_game.instance_variable_set(:@active_pieces, [king, queen])
        dummy_game.active_pieces.each { |piece| piece.generate_moves(dummy_game.board) }
      end

      it 'is single check' do
        expect(dummy_game.single_check?(king.location)).to be true
      end
    end
  end

  describe '#checkmate?' do
    # TODO
  end
end

# rubocop:enable Metrics/BlockLength
