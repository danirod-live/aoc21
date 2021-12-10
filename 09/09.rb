heights = File.read('input.txt')

def print_grid(grid)
  grid.each { |g| puts g.join }
end

def print_boolean(grid)
  grid.each { |g| puts g.map { |x| x ? 'X' : ' ' }.join }
end

def adjacents(grid, x, y)
  [].tap do |vecino|
    vecino << [x - 1, y] unless x.zero?
    vecino << [x + 1, y] unless x == grid[0].length - 1
    vecino << [x, y - 1] unless y.zero?
    vecino << [x, y + 1] unless y == grid.length - 1
  end
end

grid = heights.split("\n").map { |l| l.chars.map(&:to_i) }

lower = []
grid.each_with_index do |row, y|
  row.each_with_index do |val, x|
    vecino = adjacents(grid, x, y).map { |px, py| grid[py][px] }
    lower << val if vecino.all? { |v| v > val }
  end
end
puts lower.sum + lower.count

##############

pending = grid.map { |row| row.map { |c| c < 9 } }

def find_pending_point(pending)
  pending.each_with_index do |row, y|
    row.each_with_index do |val, x|
      return [x, y] if val
    end
  end
  nil
end

def get_points(grid, x, y)
  pendings = [[x, y]]
  resolved = []

  index = []

  while pendings.length.positive?
    px, py = pendings.pop
    resolved << [px, py]
    index << "#{px},#{py}"

    adjacents(grid, px, py).each do |nx, ny|
      this_index = "#{nx},#{ny}"
      next if grid[ny][nx] == 9
      next if index.include?(this_index)

      pendings << [nx, ny]
    end
  end

  resolved.uniq
end

cuencas = []
until find_pending_point(pending).nil?
  px, py = find_pending_point(pending)
  cuenca = get_points(grid, px, py)
  cuencas << cuenca.length

  cuenca.each do |cx, cy|
    pending[cy][cx] = false
  end
end

puts cuencas.sort.reverse.take(3).reduce(&:*)
