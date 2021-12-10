OPEN = {
  '[' => :corchete,
  '(' => :paren,
  '{' => :llave,
  '<' => :que
}

CLOSE = {
  ']' => :corchete,
  ')' => :paren,
  '}' => :llave,
  '>' => :que
}

SCORES = {
  paren: 3,
  corchete: 57,
  llave: 1197,
  que: 25_137
}

SCORES2 = {
  paren: 1,
  corchete: 2,
  llave: 3,
  que: 4
}

def incorrect(line)
  stack = []
  line.chars.each do |c|
    if OPEN.keys.include?(c)
      symbol = OPEN[c]
      stack.push(symbol)
    else
      symbol = CLOSE[c]
      expected = stack.pop
      return SCORES[symbol] if symbol != expected
    end
  end
  0
end

def autocomplete(line)
  stack = []
  line.chars.each do |c|
    if OPEN.keys.include?(c)
      symbol = OPEN[c]
      stack.push(symbol)
    else
      symbol = CLOSE[c]
      expected = stack.pop
      return SCORES[symbol] if symbol != expected
    end
  end

  stack.reverse.reduce(0) do |score, item|
    score * 5 + SCORES2[item]
  end
end

lines = File.read('input.txt').lines.map { |l| l.strip }
puts lines.map { |l| incorrect(l) }.sum

incompletes = lines.filter { |l| incorrect(l) == 0 }
scores = incompletes.map { |i| autocomplete(i) }.sort
puts scores[(scores.length - 1) / 2]
