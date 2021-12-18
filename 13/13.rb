lines = File.read('input.txt').lines.map(&:strip)
points = []
folds = []
lines.each do |line|
  next if line == ''

  if line.start_with?('fold')
    folds << line
  else
    points << line
  end
end

def print(paper)
  puts
  paper.each do |line|
    puts line.map { |f| f ? '█' : ' ' }.join
  end
end

def transpose(matrix)
  width = matrix.length
  height = matrix[0].length
  transposed = Array.new(height) { Array.new(width) }
  matrix.each_with_index do |row, j|
    row.each_with_index do |col, i|
      transposed[i][j] = col
    end
  end
  transposed
end

def actually_fold(paper, at)
  new_paper = paper.take(at)
  bottom = paper[at..]
  bottom = bottom.take(at + 1)
  bottom.each_with_index do |row, j|
    next if j.zero?

    row.each_with_index { |val, i| new_paper[-j][i] ||= val }
  end
  new_paper
end

def fold(paper, inst)
  horizontal = inst.match(/x=(\d+)/)
  vertical = inst.match(/y=(\d+)/)
  if horizontal
    value = horizontal[1].to_i
    transpose(actually_fold(transpose(paper), value))
  elsif vertical
    value = vertical[1].to_i
    actually_fold(paper, value)
  end
end

points = points.map { |point| point.split(',').map(&:to_i) }
width = points.map(&:first).max + 1
height = points.map(&:last).max + 1
paper = height.times.map { width.times.map { false } }
points.each do |x, y|
  paper[y][x] = true
end

paper_a = fold(paper, folds.first)
puts paper_a.flatten.select { |v| v }.count

paper_b = folds.reduce(paper) { |p, f| fold(p, f) }
print(paper_b)
