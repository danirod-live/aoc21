data = File.read('input.txt')

# Problem 1 seems easy
outputs = data.lines.map do |line|
  line.split(' | ')[1].strip
end
puts outputs.map(&:split).flatten.select { |word| [2, 3, 4, 7].include?(word.length) }.count

# Now, problem 2 seems difficult.
# dictionary => translates weird to known
#  aaa
# b   c    0 => abcefg    5 => abdfg
# b   c    1 => cf        6 => abdefg
# b   c    2 => acdeg     7 => acf
#  ddd     3 => acdfg     8 => abcdefg
# e   f    4 => bcdf      9 => abcdfg
# e   f
# e   f
#  ggg
conversion = {
  'abcefg' => 0,
  'cf' => 1,
  'acdeg' => 2,
  'acdfg' => 3,
  'bcdf' => 4,
  'abdfg' => 5,
  'abdefg' => 6,
  'acf' => 7,
  'abcdefg' => 8,
  'abcdfg' => 9
}
total = 0
data.lines.map(&:strip).each do |line|
  input, output = line.split(' | ')
  dictionary = {}

  numbers = input.split

  # the most easy ones are the one with different lengths
  one = numbers.find { |n| n.length == 2 }
  four = numbers.find { |n| n.length == 4 }
  seven = numbers.find { |n| n.length == 3 }
  eight = numbers.find { |n| n.length == 7 }

  # a is the letter in seven that is not in one
  dictionary['a'] = (seven.chars - one.chars).first

  # six will be the only digit with 6 segments that misses a
  # letter that is present in one
  six = numbers.find do |n|
    if n.length == 6
      up, down = one.chars
      !n.include?(up) || !n.include?(down)
    else
      false
    end
  end

  # now that i have 1 and 6, i can see what is C
  # if i know which one is C, i can guess which is F
  if six.include?(one[0])
    # one[1] is C, one[0] is F
    dictionary['c'] = one[1]
    dictionary['f'] = one[0]
  else
    # one[0] is C, one[1] is F
    dictionary['c'] = one[0]
    dictionary['f'] = one[1]
  end

  # zero = the number with six segments that is NOT six,
  # that is missing a segment that is part of four
  zero = numbers.find do |n|
    if n.length == 6 && n != six
      # differentiate between zero and nine
      (four.chars - n.chars).length.positive?
    else
      false
    end
  end

  # having the zero, we can pick the one in the middle
  dictionary['d'] = (four.chars - zero.chars)[0]

  # and now we can guess which one is B because is the one
  # that misses in four from CDF.
  dictionary['b'] = (four.chars - [dictionary['c'], dictionary['d'], dictionary['f']]).first

  # only missing the nine
  nine = numbers.find do |n|
    n.length == 6 && n != six && n != zero
  end

  # and now we can see E because is the one missing from nine
  dictionary['e'] = (eight.chars - nine.chars).first

  # and we can guess the missing one
  dictionary['g'] = (eight.chars - dictionary.values).first

  # ----------------
  reverse = dictionary.map { |k, v| [v, k] }.to_h

  translated = output.split.map do |word|
    word.chars.map { |l| reverse[l] }.sort.join
  end

  numbers = translated.map { |word| conversion[word] }
  um, c, d, u = numbers

  total += (um * 1000 + c * 100 + d * 10 + u)
end

puts total
