module Enumerable
  def my_each
    return self unless block_given?
    for i in self
      yield i
    end
  end

  def my_each_with_index
    return self unless block_given?
    for i in 0...length
      yield(self[i], i)
    end
  end

  def my_select
    return self unless block_given?
    new_array = []
    my_each { |elem| new_array << elem if yield(elem) }
    new_array
  end

  def my_all?
    if block_given?
      my_each { |elem| return false unless yield(elem) }
    else
      my_each { |elem| return false unless elem }
    end
    true
  end

  def my_any?
    if block_given?
      my_each { |elem| return true if yield(elem) }
    else
      my_each { |elem| return true if elem }
    end
    false
  end

  def my_none?
    if block_given?
      my_each { |elem| return false if yield(elem) }
    else
      my_each { |elem| return false if elem }
    end
    true
  end

  def my_count(arg = nil)
    c = 0
    if block_given?
      my_each { |elem| c += 1 if yield(elem) }
    elsif arg.nil?
      c = length
    else
      my_each { |elem| c += 1 if elem == arg }
    end
    return c
  end

  def my_map
    new_array = []
    if block_given?
      my_each { |elem| new_array << yield(elem) }
    else
      return to_enum
    end
    return new_array
  end

  def my_map_with_proc(proc_arg)
    new_array = []
    if !proc_arg.nil?
      my_each { |elem| new_array << proc_arg.call(elem) }
    else
      return to_enum
    end
    return new_array
  end

  def my_map_modified(proc_arg)
    new_array = []
    if proc_arg.nil?
      return to_enum
    else
      my_each { |elem| new_array << yield(proc_arg.call(elem)) }
    end
    return new_array
  end

  def my_inject(num = nil)
    accumulator = num.nil? ? first : num
    my_each { |elem| accumulator = yield(accumulator, elem) }
    return accumulator
  end
end

def multiply_els(input)
  input.my_inject { |total, elem| total * elem }
end

input = [1, 2, 2, 2, 3, 4, 5]

puts input.my_map_modified(Proc.new { |elem| elem ** 2 }) { |elem| elem += 1 }
