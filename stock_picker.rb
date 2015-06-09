def stock_picker(input)
  buy_day = 0
  sell_day = 0
  max_profit = 0
  input.each_with_index do |buy_price, i|
    input[i+1..-1].each_with_index do |sell_price, j|
      if (sell_price - buy_price) > max_profit
        max_profit = sell_price - buy_price
        buy_day = i
        sell_day = j + i + 1
      end
    end
  end
  return [buy_day, sell_day]
end
