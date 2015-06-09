class Game
  attr_accessor :move, :computer_move

  def initialize()
    @move = move
    @computer_move = @computer_move
  end

  MOVES = { "rock" => "paper", "paper" => "scissors", "scissors" => "rock" }

  def play
    loop do
      player_move
      computer_move
      game_over
      break
    end
  end

  def player_move
    puts "What's your move? [rock, paper, scissors]: "
    @move = gets.chomp.downcase
  end

  def computer_move
    chance = rand(1..3) 
    case chance
    when 1
      @computer_move = "rock"
    when 2
      @computer_move = "paper"
    when 3
      @computer_move = "scissors"
    end
  end

  def game_over
    if MOVES[@move] == @computer_move
      puts "You lost! #{@move} lost to #{@computer_move}"
    elsif @computer_move == @move
      puts "It's a draw!"
    else
      puts "You won! #{@computer_move} lost to #{@move}"
    end
    another_turn
  end

  def another_turn
    puts "Do you want to play more? [y/n]: "
    reply = gets.chomp.downcase
    case reply
    when "y"
      play
    when "n"
      return false
    else
      puts "Wrong answer"
      another_turn
    end
  end
end

game = Game.new
game.play
