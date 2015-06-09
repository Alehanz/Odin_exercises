class Array
  def all_same?
    self.all? { |element| element == self[0] }
  end

  def all_empty?
    self.all? { |element| element.to_s.empty? }
  end

  def any_empty?
    self.any? { |element| element.to_s.empty? }
  end

  def none_empty?
    !any_empty?
  end
end

class Board
  attr_reader :grid
  def initialize(input = {})
    @grid = input.fetch(:grid, default_grid)
  end

  def get_cell(x, y)
    grid[x][y]
  end

  def set_cell(x, y, mark)
    get_cell(x, y).value = mark
  end

  def formatted_grid
    grid.each do |row|
      puts row.map { |cell| cell.value.empty? ? "_" : cell.value }.join(" ")
    end
  end


  def game_over
    return :winner if winner?
    return :draw if draw?
    false
  end

  def winner?
    winning_positions.each do |winning_position|
      next if winning_position_values(winning_position).all_empty?
      return true if winning_position_values(winning_position).all_same?
    end
    false
  end

  def draw?
    grid.flatten.map { |cell| cell.value }.none_empty?
  end

  def winning_position_values(winning_position)
    winning_position.map { |cell| cell.value }
  end

  private

  def winning_positions
    grid + grid.transpose + diagonals
  end

  def diagonals
    [
      [get_cell(0, 0), get_cell(1, 1), get_cell(2, 2)],
      [get_cell(2, 0), get_cell(1, 1), get_cell(0, 2)]
    ]
  end

  def default_grid
    Array.new(3) { Array.new(3) { Cell.new } }
  end
end

class Player
  attr_accessor :name, :mark
  def initialize(input)
    @name = input.fetch(:name)
    @mark = input.fetch(:mark)
  end
end

class Cell
  attr_accessor :value
  def initialize(value = "")
    @value = value
  end
end

class Game
  attr_reader :players, :board, :current_player, :other_player
  def initialize(players, board = Board.new)
    @players = players
    @current_player, @other_player = players.shuffle
    @board = board
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def solicit_move
    "Please enter your move (1-9): "
  end

  def get_move(move = gets.chomp)
    players_move_to_coordinates(move)
  end

  def players_move_to_coordinates(move)
    coordinates = {
      "1" => [0, 0],
      "2" => [0, 1],
      "3" => [0, 2],
      "4" => [1, 0],
      "5" => [1, 1],
      "6" => [1, 2],
      "7" => [2, 0],
      "8" => [2, 1],
      "9" => [2, 2]
    }
    coordinates[move]
  end

  def play
    puts "#{current_player.name}'s turn now!"
    while true
      board.formatted_grid
      puts ""
      puts solicit_move
      x, y = get_move
      board.set_cell(x, y, current_player.mark)
      if board.game_over
        puts game_over_message
        board.formatted_grid
        return
      else
        switch_players
      end
    end
  end

  def game_over_message
    return "#{current_player.name} has won!" if board.game_over == :winner
    return "It's a draw!" if board.game_over == :draw
  end

end

bob = Player.new({ name: "Bob", mark: "X" })
mark = Player.new({ name: "Mark", mark: "O" })
players = [bob, mark]

Game.new(players).play
