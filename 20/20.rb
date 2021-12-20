def read_file(file)
  algo, _, *map = File.read(file).lines.map(&:strip)
  [algo, map]
end

@algo, @map = read_file('input.txt')

def point_at(map, x, y)
  return '.' if x < 0 || y < 0 || x >= map.length || y >= map[0].length

  map[y][x]
end

def bigger(map, count)
  horizontal = map.map { |r| "#{'.' * count}#{r}#{'.' * count}" }
  vertical = count.times.map { '.' * horizontal[0].length }
  vertical + horizontal + vertical
end

def smaller(map, count)
  start = count
  finish = -count - 1
  map[start..finish].map { |row| row[start..finish] }
end

def around(x, y)
  pos = []
  ((y - 1)..(y + 1)).each do |ry|
    ((x - 1)..(x + 1)).each do |rx|
      pos << [rx, ry]
    end
  end
  pos
end

def hash(map, x, y)
  around(x, y).map { |x, y| point_at(map, x, y) }
              .map { |v| v == '#' ? '1' : 0 }
              .join.to_i(2)
end

def enhance(map)
  new_map = []
  map.map.each_with_index do |row, y|
    new_row = ''
    row.chars.each_with_index do |_, x|
      here = hash(map, x, y)
      new_row += @algo[here]
    end
    new_map << new_row
  end
  new_map
end

def crop(map)
  without_vertical = map.reject { |row| row.chars.reject { |x| x == '.' }.empty? }

  first_pound = without_vertical.map { |r| r.index('#') }.min
  last_pound = without_vertical.map { |r| r.rindex('#') }.max
  without_vertical.map { |row| row[first_pound..last_pound] }
end

def debug(map)
  map.each { |r| puts r }
end

map = @map
25.times.each do |i|
  map = crop(smaller(enhance(enhance(bigger(map, map.length))), 2))

  puts map.join.chars.select { |c| c == '#' }.count if [0, 24].include?(i)
end
