input = File.read('input.txt').split("\n")

depth = 0
pos = 0

input.each do |line|
  movement, count = line.split(' ')
  count = count.to_i
  case movement
  when 'forward'
    pos += count
  when 'up'
    depth -= count
  when 'down'
    depth += count
  end
end
puts depth * pos

aim = 0
depth = 0
pos = 0

input.each do |line|
  movement, count = line.split(' ')
  count = count.to_i

  case movement
  when 'down'
    aim += count
  when 'up'
    aim -= count
  when 'forward'
    pos += count
    depth += (aim * count)
  end
end
puts depth * pos
