# We take in a file of words, the dictionary. So we use something like
# File.open("5desk.txt", r). We don't need to write to the file, so we use the r
# mode to open it.
# Then we filter those words and only select the ones that are between 5 and 12
# characters long. So we do something like dictionary = dictionary.select { |word|
# word.length >= 5 && word.length <= 12 }
# Then we need to pick one word for the game out of the filtered dictionary.
# Something like dictionary.sample(1) or something along the lines. Depends on
# what construction the Dictionary file is. If it's a long string, we should
# split it on newlines and into an array.
# So lets say there has to be 12 wrong tries or less for the game. We can keep track
# of this inside the game class. After each turn we need to display the amount
# of tries left for the player.
# We should also display the word with the missing letters replaced with "_" and
# also display the letters the player tried guessing maybe?
#
# Lets describe the main play method of the Game class:
# it puts "The word was selected, it's time to guess it"
# Start loop here
# then it prompts for you input with puts "What letter do you choose?: "
# then it gets.chomp the letter and possible adds it to the player.answer array.
# Then we need to scan the word in the AI class probably and see if
# player.answer matches any letters in the Ai.word.
# if game_over?
# puts game_over_message
# else
# If it does, replace the "_" at the correct place with the letter.
# If it does not, increment the tries.
# end loop here
#
# Some pseudo code:
# def formatted_word(word)
#   word.map { |letter| letter = "_" }
# end
#
# def guess_letter(input)
#   index = ai.word.find_index(input)
#   index.each do |i|
#     formatted_word[i] = input
#   end
# end
#
# def play
#   puts "The word was selected- it's time to guess it!"
#   loop do
#     puts "Enter the letter you choose: "
#     player.input << gets.chomp.downcase
#     guess_letter(player.input.last)
#     puts board.formatted_word
#     if game_over?
#       puts game_over_message
#   end
# end

require "pry"

class Player
  attr_accessor :input
  def initialize(name)
    @name = name
    @input = []
  end
end

class Ai
  attr_reader :word
  attr_accessor :hidden_word
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

class Game
  attr_accessor :player, :ai, :tries
  def initialize(player, ai)
    @player = player
    @ai = ai
    @tries = 10
  end

  def play
    puts "The word was selected, it's time to guess it!"
    puts ai.hidden_word
    puts ai.word
    loop do
      puts "Enter the letter you choose: "
      player.input << gets.chomp.downcase
      guess_letter(player.input.last)
      puts ai.hidden_word
      if game_over
        puts game_over_message
      end
      @tries -= 1
    end
  end

  private

  def game_over
    return :winner if winner?
    return :loser if loser?
    false
  end

  def winner?
    !ai.hidden_word.include?("_")
  end

  def loser?
    tries < 1
  end

  def game_over_message
    return "You won!" if game_over == :winner
    return "You lost!" if game_over == :loser
  end

  def guess_letter(input)
    (0...ai.word.length).each do |index|
      if ai.word[index] == input
        ai.hidden_word[index] = input
      end
    end
  end
end

ai = Ai.new("5desk.txt")
player = Player.new("Alex")
Game.new(player, ai).play
