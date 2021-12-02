input = File.read('input.txt').split.map(&:to_i)
last = nil
count = 0

input.each do |i|
  count += 1 if last && i > last
  last = i
end

first, second, *rest = input
last = nil
count = 0
rest.each do |r|
  sum = first + second + r

  count += 1 if last && sum > last
  last = sum
  first = second
  second = r
end

puts count
puts count
