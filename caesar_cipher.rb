def caesar_cipher(input, shift)
  text = input.split("")
  shift = shift.to_i % 26
  result = ""
  text.each do |letter|
    letter = letter.ord
    if (letter >= 65) && (letter <= 90)
      letter = letter + shift
      if letter > 90
        letter = letter - 26
      end
      result << letter.chr
    elsif (letter >= 97) && (letter <= 122)
      letter = letter + shift
      if letter > 122
        letter = letter - 26
      end
      result << letter.chr
    else
      result << letter.chr
    end
  end
  result
end

puts caesar_cipher("What a string!", 5)


def caesar_cipher2(input, shift)
  positions = input.unpack("C*")
  shifted_positions = positions.map do |pos|
    case pos
      when (65..90), (97..122)
        shifted = pos + (shift % 26)
        if (shifted > 90 && shifted < 97) || (shifted > 122)
          shifted = shifted - 26
        end
        pos = shifted
      else
        pos
    end
  end
  result = shifted_positions.pack("C*")
  puts result
end

puts caesar_cipher2("What a string!", 5)
