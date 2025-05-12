# frozen_string_literal: true

require_relative 'player'

# Game class
class Game
  def initialize
    @players = []
    @board = (1..9).to_a
  end

  def start
    puts 'Welcome to Tic Tac Toe!'

    player1 = Player.new('Player 1', 'X', @board)
    player2 = Player.new('Player 2', 'O', @board)

    @players = [player1, player2]
    @current_player = @players.first

    puts 'Player 1 is X, Player 2 is O'
    game_loop
  end

  def game_loop
    player_move until game_over?
    display_board
    puts 'Game Over'
  end

  def player_move
    display_board
    success_move = false
    until success_move
      puts "#{@current_player.name}, please select a position"
      position = gets.chomp.to_i - 1
      success_move = @current_player.select_position(position)
    end
    @current_player = switch_player(@current_player)
  end

  def switch_player(current_player)
    current_player == @players[0] ? @players[1] : @players[0]
  end

  def game_over?
    check_winner || @board.all? { |cell| cell.is_a?(String) }
  end

  def check_winner
    winning_combinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]
    if winning_combinations.any? do |combo|
      @board[combo[0]] == @board[combo[1]] && @board[combo[1]] == @board[combo[2]]
    end
      puts "#{@current_player.name} wins!"
      true
    else
      false
    end
  end

  def display_board
    puts "#{@board[0]} | #{@board[1]} | #{@board[2]}"
    puts '---------'
    puts "#{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts '---------'
    puts "#{@board[6]} | #{@board[7]} | #{@board[8]}"
  end
end
