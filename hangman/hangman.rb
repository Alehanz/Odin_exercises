require "pry"
require "yaml"

class Player
  attr_reader :name
  attr_accessor :input, :bad_guess
  def initialize(name)
    @name = name
    @input = []
  end
end

class Ai
  attr_accessor :hidden_word, :word
  def initialize(dictionary)
    @dictionary = filter_words(dictionary)
    @word = pick_word
    @hidden_word = hide_word
  end

  private

  def filter_words(file)
    file = File.new(file, "r")
    file = file.read
    @dictionary = file.split("\n").select { |word| word.length >= 5 && word.length <= 12 }
  end

  def hide_word
    "_" * @word.length
  end

  def pick_word
    @dictionary.sample(1).join
  end
end

class GameFile
  attr_reader :location
  def initialize(location)
    @location = location
  end

  def write(file)
    File.open(location, "w") do |f|
      f.puts(file)
    end
  end

  def read
    File.open(location, "r") do |f|
      f.read
    end
  end
end

class Game
  attr_accessor :player, :ai, :tries
  def initialize(player, ai)
    @player = player
    @ai = ai
    @tries = 18
  end

  def play
    load_choice
    puts "The word was selected, it's time to guess it!"
    puts ai.hidden_word
    loop do
      save_choice
      get_input
      guess_letter(player.input.last)
      puts ai.hidden_word
      hints
      @tries -= 1
      if game_over
        puts game_over_message
        break
      end
      puts "Tries: #{@tries}"
    end
  end

  private

  def load_choice
    loop do
      puts "Would you like to load a save file? [Y/N]: "
      response = gets.chomp.upcase
      case response
      when "Y"
        load_game
        puts "Game loaded!"
        return
      when "N"
        return
      else
        puts "Bad input, try again"
      end
    end
  end

  def save_choice
    loop do
      puts "Would you like to guess a [L]etter or [S]ave the game? [L, S]: "
      response = gets.chomp.upcase
      case response
      when "L"
        return
      when "S"
        save_game
        puts "Game saved!"
      else
        puts "Wrong input, try again"
      end
    end
  end

  def get_input
    puts "Enter the letter you choose: "
    player.input << gets.chomp.downcase
  end

  def guess_letter(input)
    (0...ai.word.length).each do |index|
      if ai.word[index] == input
        ai.hidden_word[index] = input
      end
    end
  end

  def hints
    puts "The letters you've tried so far: "
    puts player.input.join(", ")
  end

  def game_over
    return :winner if winner?
    return :loser if loser?
    false
  end

  def winner?
    !ai.hidden_word.include?("_")
  end

  def loser?
    tries == 0
  end

  def game_over_message
    return "#{player.name} won!" if game_over == :winner
    return "You lost! The word was: #{ai.word}" if game_over == :loser
  end

  def save_game
    yaml = YAML::dump([ai.word, ai.hidden_word, @tries, player.input])
    save_file = GameFile.new("save_file")
    save_file.write(yaml)
  end

  def load_game
    save_file = GameFile.new("save_file")
    game_state = save_file.read
    d = YAML::load(game_state)
    ai.word = d[0]
    ai.hidden_word = d[1]
    @tries = d[2]
    player.input = d[3]
  end
end

ai = Ai.new("5desk.txt")
player = Player.new("Alex")
Game.new(player, ai).play
