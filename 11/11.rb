def debug(state)
  puts '==='
  state.each { |r| puts r.inspect }
  puts '==='
end

def step(state, flash)
  flash_here = 0
  inc = state.map { |r| r.map { |v| v + 1 } }
  while inc.flatten.include?(10)
    inc.each_with_index do |row, y|
      row.each_with_index do |_, x|
        next unless inc[y][x] >= 10

        inc[y][x] = 0
        flash_here += 1

        ((x - 1)..(x + 1)).each do |dx|
          next if dx.negative? || dx >= inc.length

          ((y - 1)..(y + 1)).each do |dy|
            next if dy.negative? || dy >= row.length
            next if inc[dy][dx].zero? || inc[dy][dx] == 10

            inc[dy][dx] = inc[dy][dx] + 1
          end
        end
      end
    end
  end
  inc = inc.map { |row| row.map { |v| v > 9 ? 0 : v } }
  [inc, flash_here + flash]
end

data = File.read('input.txt').lines.map { |row| row.strip.chars.map(&:to_i) }
flash = 0
100.times.each do
  data, flash = step(data, flash)
end
puts flash

data = File.read('input.txt').lines.map { |row| row.strip.chars.map(&:to_i) }
i = 0
while data.flatten.any?(&:positive?)
  data, = step(data, 0)
  i += 1
end
puts i
