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

    context 'when no pieces can attack the king' do
      let(:queen) { Queen.new("\u265B", 'white', [7, 3]) }
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', queen, '   ', '   ', '   ', '   ']
        ]
      end

      before do
        dummy_game.board.instance_variable_set(:@cells, positions)
        dummy_game.instance_variable_set(:@active_pieces, [king, queen])
        dummy_game.active_pieces.each { |piece| piece.generate_moves(dummy_game.board) }
      end

      it 'is not single check' do
        expect(dummy_game.single_check?(king.location)).to be false
      end
    end
  end

  describe '#checkmate?' do
    let(:king) { King.new("\u2654", 'black', [0, 4]) }
    let(:bpwn) { Pawn.new('p', 'black', [1, 5]) }
    let(:bpwn2) { Pawn.new('p', 'black', [1, 3]) }
    let(:queen) { Queen.new("\u265B", 'white', [7, 4]) }
    let(:rook) { Rook.new('r', 'white', [0, 0]) }

    context 'when the king is in double check and no moves available' do
      let(:positions) do
        [
          [rook, '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', bpwn2, '   ', bpwn, '   ', '   '],
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
        dummy_game.generate_piece_moves
        allow(dummy_game).to receive(:locate_king).and_return(king)
        allow(dummy_game).to receive(:double_check?).and_return(true)
        allow(dummy_game).to receive(:king_move_available?).with(king).and_return(false)
      end
      it 'is checkmate' do
        expect(dummy_game.checkmate?).to be true
      end
    end

    context 'when the king is in double check but has a move available' do
      let(:positions) do
        [
          [rook, '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', bpwn, '   ', '   '],
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
        dummy_game.generate_piece_moves
        allow(dummy_game).to receive(:locate_king).and_return(king)
        allow(dummy_game).to receive(:double_check?).and_return(true)
        allow(dummy_game).to receive(:king_move_available?).with(king).and_return(true)
      end

      it 'is not checkmate' do
        expect(dummy_game.checkmate?).to be false
      end
    end

    context 'when the king is in single check and has a move available' do
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', bpwn, '   ', '   '],
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
        dummy_game.generate_piece_moves
        allow(dummy_game).to receive(:locate_king).and_return(king)
        allow(dummy_game).to receive(:single_check?).and_return(true)
        allow(dummy_game).to receive(:king_move_available?).with(king).and_return(true)
      end

      it 'is not checkmate' do
        expect(dummy_game.checkmate?).to be false
      end
    end

    context 'when the king is in single check and a blocking move is available' do
      let(:bish) { Bishop.new('b', 'black', [1, 3]) }
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', bish, '   ', bpwn, '   ', '   '],
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
        dummy_game.generate_piece_moves
        allow(dummy_game).to receive(:locate_king).and_return(king)
        allow(dummy_game).to receive(:single_check?).and_return(true)
        allow(dummy_game).to receive(:king_move_available?).with(king).and_return(false)
        allow(dummy_game).to receive(:blocking_move?).and_return(true)
      end

      it 'is not checkmate' do
        expect(dummy_game.checkmate?).to be false
      end
    end
  end

  describe '#king_move_available?' do
    # TODO
  end

  describe '#blocking_move?' do
    # TODO
  end

  describe '#can_capture?' do
    let(:queen) { Queen.new('q', 'white', [2, 4]) }
    let(:king) { King.new("\u2654", 'black', [0, 4]) }

    before do
      dummy_game.board.instance_variable_set(:@cells, positions)
      dummy_game.generate_piece_moves
      dummy_game.instance_variable_set(:@can_attack_king, [queen])
    end

    context 'when the attacking piece can be captured' do
      let(:bpwn) { Pawn.new('p', 'black', [1, 5]) }
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', bpwn, '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
        ]
      end

      it 'can capture' do
        expect(dummy_game.can_capture?(bpwn)).to be true
      end
    end

    context 'when the attacking piece cannot be captured' do
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
        ]
      end

      it 'cannot capture' do
        expect(dummy_game.can_capture?(king)).to be false
      end
    end
  end

  describe '#can_block?' do
    # TODO
  end

  describe '#path_to_king' do
    let(:queen) { instance_double(Queen, marker: 'q', color: 'white', location: [2, 4]) }
    let(:king) { instance_double(King, marker: 'k', color: 'black', location: [0, 4]) }
    let(:positions) do
      [
        ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', queen, '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
        ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
      ]
    end

    before do
      dummy_game.board.instance_variable_set(:@cells, :positions)
    end
    context 'when the attacking piece and king are in the same column' do
      it 'returns the column path' do
        expect(dummy_game).to receive(:col_path)
        dummy_game.path_to_king(queen, king)
      end

      it 'returns the correct path' do
        path = dummy_game.path_to_king(queen, king)
        expect(path).to eq([[1, 4]])
      end
    end

    context 'when the attacking piece and king are in the same row' do
      let(:queen) { instance_double(Queen, marker: 'q', color: 'white', location: [0, 0]) }
      let(:positions) do
        [
          [queen, '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
        ]
      end

      it 'returns the row path' do
        expect(dummy_game).to receive(:row_path)
        dummy_game.path_to_king(queen, king)
      end

      it 'returns the correct path' do
        path = dummy_game.path_to_king(queen, king)
        expect(path).to eq([[0, 1], [0, 2], [0, 3]])
      end
    end

    context 'when the attacking piece is attacking diagonally' do
      let(:queen) { instance_double(Queen, marker: 'q', color: 'white', location: [2, 2]) }
      let(:positions) do
        [
          ['   ', '   ', '   ', '   ', king, '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', queen, '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
          ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
        ]
      end

      it 'returns the diagonal path' do
        expect(dummy_game).to receive(:diagonal_path)
        dummy_game.path_to_king(queen, king)
      end

      it 'returns the correct path' do
        path = dummy_game.path_to_king(queen, king)
        expect(path).to eq([[1, 3]])
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
