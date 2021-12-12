data = File.read('input.txt').lines

def key(x, y)
  [x, y].join(',')
end

def resolver(data, diagonal)
  map = {}
  data.each do |line|
    x1, y1, x2, y2 = line.match(/(\d+),(\d+) -> (\d+),(\d+)/)[1..4].map(&:to_i)
    next unless x1 == x2 || y1 == y2 || (x1 - x2).abs == (y1 - y2).abs

    if x1 == x2
      ymin, ymax = [y1, y2].minmax
      (ymin..ymax).each do |dy|
        map[key(x1, dy)] = 0 unless map[key(x1, dy)]
        map[key(x1, dy)] += 1
      end
    elsif y1 == y2
      xmin, xmax = [x1, x2].minmax
      (xmin..xmax).each do |dx|
        map[key(dx, y1)] = 0 unless map[key(dx, y1)]
        map[key(dx, y1)] += 1
      end
    elsif diagonal
      dx = x1 < x2 ? 1 : -1
      dy = y1 < y2 ? 1 : -1
      x = x1
      y = y1
      loop do
        map[key(x, y)] = 0 unless map[key(x, y)]
        map[key(x, y)] += 1
        break if x == x2 && y == y2

        x += dx
        y += dy
      end
    end
  end
  map.values.filter { |v| v >= 2 }.count
end

puts resolver(data, false)
puts resolver(data, true)
