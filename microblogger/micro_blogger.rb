require "jumpstart_auth"
require "pry"

class MicroBlogger
  attr_reader :client
  
  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
    unless message.length > 140 
      @client.update(message)
    else
      puts "Can't post tweets longer than 140 sybmols"
    end
  end

  def dm(target, message)
    puts "Trying to send #{target} this direct message"
    puts message
    message = "d #{target} #{message}"
    tweet(message)
  end

  def follower_list
    @screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
  end

  def spam_my_followers(message)
    @screen_names.each { |follower| dm(follower, "#{message}") }
  end
  
  def everyones_last_tweet
    friends = @client.friends
    friends.each do |friend|
      binding.pry
      message = friend.status.source
      created_at = friend.status.created_at
      puts friend.screen_name
      puts message
    end
    puts ""
  end

  def run
    puts "Welcome to this wonderful Twitter client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
      when "q" then puts "Goodbye!"
      when "t" then tweet(parts[1..-1].join(" "))
      when "dm" then dm(parts[1], parts[2..-1].join(" "))
      when "spam" then spam_my_followers(parts[-1])
      when "elt" then everyones_last_tweet
      else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end
end

blogger = MicroBlogger.new
blogger.run
