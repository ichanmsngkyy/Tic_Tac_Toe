# frozen_string_literal: true

# Player class
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol, game_board)
    @name = name
    @symbol = symbol
    @game_board = game_board
  end

  def select_position(position)
    if (0..8).include?(position) && @game_board[position].is_a?(Integer)
      @game_board[position] = @symbol
      true
    else
      puts 'Invalid position, please select a number between 0 and 8'
      false
    end
  end
end
