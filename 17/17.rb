tx = 150..171
ty = -129..-70

# tx = 20..30
# ty = -10..-5

def serie(n)
  return [] if n <= 0

  [n] + serie(n - 1).map { |v| n + v }
end

def parabola(vy, min)
  valores = [vy]
  while valores.last > min
    vy -= 1
    valores << valores.last + vy
  end
  valores
end

candidates_x = (tx.max + 1).times.filter { |n| serie(n).any? { |x| tx.include?(x) } }

candidates = []

max = -2000
candidates_x.each do |cx|
  values = serie(cx)
  up_to = values.index { |x| x > tx.max } || values.length

  500.times.each do |i|
    cy = ty.min + i
    par = parabola(cy, ty.min - 1)

    par.each_with_index do |y, idy|
      next unless ty.include?(y)

      x = if idy < values.length
            values[idy]
          else
            values.last
          end
      if tx.include?(x)
        candidates << "#{cx},#{cy}"
        max = par.max if par.max > max
      end
    end
  end
end

puts max
puts candidates.uniq.length
