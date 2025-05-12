require_relative '../lib/game'
require_relative '../lib/player'

describe Game do
  let(:game) { Game.new }
  let(:player1) { instance_double(Player, name: 'Player 1', symbol: 'X') }
  let(:player2) { instance_double(Player, name: 'Player 2', symbol: 'O') }

  describe '#initialize' do
    it 'creates a new game with an empty board numbered 1-9' do
      game = Game.new
      expect(game.instance_variable_get(:@board)).to eq((1..9).to_a)
    end

    it 'initialize an array for a player to store moves' do
      game = Game.new

      expect(game.instance_variable_get(:@players)).to eq([])
    end
  end

  describe '#switch_players' do
    before do
      game.instance_variable_set(:@players, [player1, player2])
    end
    it 'returns the turn to player 2' do
      expect(game.switch_player(player1)).to eq(player2)
    end

    it 'returns the turn to player 1' do
      expect(game.switch_player(player2)).to eq(player1)
    end
  end

  describe '#player_move' do
    before do
      game.instance_variable_set(:@players, [player1, player2])
      game.instance_variable_set(:@current_player, player1)
      allow(game).to receive(:puts)
    end

    it 'accepts valid moves and switches player' do
      allow(game).to receive(:gets).and_return('3')
      allow(player1).to receive(:select_position).with(2).and_return(true)

      game.player_move
      expect(game.instance_variable_get(:@current_player)).to eq(player2)
    end

    it 'rejects invalid moves and ask again' do
      allow(game).to receive(:gets).and_return('10', '3')
      allow(player1).to receive(:select_position).with(9).and_return(false)
      allow(player1).to receive(:select_position).with(2).and_return(true)
      game.player_move
      expect(game.instance_variable_get(:@current_player)).to eq(player2)
    end
  end

  describe '#game_over' do
    before do
      game.instance_variable_set(:@players, [player1, player2])
      game.instance_variable_set(:@current_player, player1)
      allow(game).to receive(:puts) # Suppressing output
    end

    context 'when a player has won' do
      it 'returns true and prints a message when check_winner is true' do
        allow(game).to receive(:check_winner).and_return(true)
        expect(game.game_over?).to be(true)
      end
    end

    context 'when the game is still in progress' do
      it 'returns false when moves are still available' do
        game.instance_variable_set(:@board, ['X', 'O', 'X', 4, 5, 6, 7, 8, 9]) # Not full
        allow(game).to receive(:check_winner).and_return(false) # No winner yet
        expect(game.game_over?).to be false
      end
    end
  end

  describe '#check_winner' do
    let(:winning_combinations) do
      [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
        [0, 4, 8], [2, 4, 6]             # Diagonals
      ]
    end

    before do
      allow(game).to receive(:puts)
      game.instance_variable_set(:@players, [player1, player2])
      game.instance_variable_set(:@current_player, player1)
    end

    it 'detects all possible winnin combination for X' do
      winning_combinations.each do |combo|
        board = (1..9).to_a
        combo.each { |index| board[index] = 'X' }
        game.instance_variable_set(:@board, board)
        expect(game).to receive(:puts).with("#{game.instance_variable_get(:@current_player).name} wins!")
        expect(game.check_winner).to be(true)
      end
    end

    it 'detects all possible winning combination for O' do
      winning_combinations.each do |combo|
        board = (1..9).to_a
        combo.each { |index| board[index] = 'O' }
        game.instance_variable_set(:@board, board)
        expect(game).to receive(:puts).with("#{game.instance_variable_get(:@current_player).name} wins!")
        expect(game.check_winner).to be(true)
      end
    end

    it 'returns false when no winning combination is present' do
      game.instance_variable_set(:@board, %w[X O X O X O O X O])

      expect(game.check_winner).to be false
    end
  end

  describe '#display_board' do
    before do
      @game = Game.new
      @game.instance_variable_set(:@board, %w[X O X O X O X O X])
    end

    it 'displays the board correctly' do
      expected_output = <<~BOARD
        X | O | X
        ---------
        O | X | O
        ---------
        X | O | X
      BOARD

      expect { @game.display_board }.to output(expected_output).to_stdout
    end
  end
end
