class Board
  attr_reader :grid
  attr_accessor :turn

  def initialize(input = {})
    @grid = input.fetch(:grid, standard_grid)
    @turn = 1
  end

  def current_row
    @grid[turn - 1]
  end

  def set_values(choice)
    index = -1
    current_row.map! do |cell|
      index += 1
      cell = choice[index]
    end
  end

  def set_hints(right_color, right_position)
    current_row[5] = (("+|" * right_color) + ("*|" * right_position))
  end

  def display
    title
    formatted_grid
  end

  private

  def title
    puts "Pegs:        Hints:"
  end

  def formatted_grid
    grid.each do |row|
      row[4] = "  |  "
      puts row.map { |cell| cell.nil? ? "_" : cell }.join("|")
    end
  end

  def standard_grid
    Array.new(12) { Array.new(6) }
  end
end

class Player
  attr_accessor :code

  def initialize()
    @code = []
  end

  def set_code
    puts "Set your colors left to right separated by a single space (R|G|B|P): "
    @code = gets.chomp.split(" ")
  end
end

class Ai
  attr_reader :values
  attr_accessor :code

  def initialize()
    @code = []
    @values = ["R", "G", "B", "P"] * 4
  end

  def set_code
    @code = values.sample(4)
  end
end

class Game
  attr_reader :player, :ai, :board
  attr_accessor :codebreaker, :codemaker

  def initialize(board = Board.new, ai = Ai.new, player = Player.new)
    @board = board
    @player = player
    @ai = ai
  end

  def play
    puts legend
    select_role
    codemaker.set_code
    loop do
      board.display
      puts ""
      codebreaker.set_code
      board.set_values(codebreaker.code)
      prepare_hints
      if game_over
        board.display
        puts game_over_message
        return
      end
      board.turn += 1
    end
  end

  private

  def select_role
    puts "Please select your role (Codemaker/Codebreaker): "
    role = gets.chomp.downcase
    if role == "codemaker"
      @codebreaker = ai
      @codemaker = player
    elsif role == "codebreaker"
      @codebreaker = player
      @codemaker = ai
    end
  end

  def legend
    "COLOR OPTIONS:
     Red -> R,
     Green -> G,
     Blue -> B,
     Purple -> P

     + means the color of the peg is right, but the position is wrong.

     * means both the color and the position of the peg are right.
    "
  end

  def prepare_hints
    count_hints(codebreaker.code)
    equalize_hints
    set_hints
  end

  def count_hints(choice)
    overlap = choice & codemaker.code
    @right_color = overlap.length
    @right_position = 0
    choice.each_index do |index|
      if choice[index] == codemaker.code[index]
        @right_position += 1
      end
    end
  end

  def equalize_hints
    if @right_color + @right_position > 4
      @right_color = 4 - @right_position
    end
  end

  def set_hints
    board.set_hints(@right_color, @right_position)
  end

  def game_over
    return :winner if winner?
    return :loser if loser?
    false
  end

  def game_over_message
    return "The Codebreaker won!" if game_over == :winner
    return "The Codebreaker lost! The code was: #{codemaker.code.join(" ")}" if game_over == :loser
  end

  def winner?
    codebreaker.code == codemaker.code
  end

  def loser?
    board.turn == 12 && !winner?
  end
end

Game.new.play
