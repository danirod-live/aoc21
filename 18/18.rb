# frozen_string_literal: true

require 'json'

def paths(number, parent = [])
  left, right = number
  ps = []
  if left.is_a?(Numeric)
    ps << parent + [0]
  else
    ps += paths(left, parent + [0])
  end
  if right.is_a?(Numeric)
    ps << parent + [1]
  else
    ps += paths(right, parent + [1])
  end
  ps
end

def extract(number, path)
  rel = number
  while path.length.positive?
    rel = rel[path[0]]
    path = path[1..]
  end
  rel
end

def add(number, path, value)
  rel = number
  while path.length > 1
    rel = rel[path[0]]
    path = path[1..]
  end
  rel[path[0]] += extract(number, value)
end

def set(number, path, value)
  rel = number
  while path.length > 1
    rel = rel[path[0]]
    path = path[1..]
  end
  rel[path[0]] = value
end

def reduce(number)
  final_number = JSON.parse(JSON.dump(number))
  ps = paths(final_number)

  if ps.any? { |p| p.length > 4 }
    # a pair in the number is deeper than 4
    ps.each_with_index do |path, idx|
      next unless path.length > 4

      # left
      if idx > 0
        prev = ps[idx - 1]
        add(final_number, prev, path)
      end

      # right
      after_this_pair = ps[idx + 2]
      my_friend = ps[idx + 1]

      # if this unless fails, is because this pair [val, after_this_pair] was
      # the last one in the number anyway, so there is nothing after this
      add(final_number, after_this_pair, my_friend) unless after_this_pair.nil?

      # replace all this pair with a zero
      *parent, _ = path
      set(final_number, parent, 0)

      return reduce(final_number)
    end
  elsif ps.any? { |p| extract(final_number, p) >= 10 }
    # a primitive number in this number is bigger or greater than 10
    ps.each do |p|
      value = extract(final_number, p)
      next unless value >= 10

      left = (value.to_f / 2).floor
      right = (value.to_f / 2).ceil
      set(final_number, p, [left, right])
      return reduce(final_number)
    end
  end

  final_number
end

def sum(*pars)
  pars
end

def magnitude(number)
  return number if number.is_a?(Numeric)

  left, right = number
  3 * magnitude(left) + 2 * magnitude(right)
end

sums = File.read('input.txt').lines.map { |r| JSON.parse(r) }

first, *rest = sums
rest.each do |r|
  first = reduce(sum(first, r))
end
puts magnitude(first)

mags = []
sums.each_with_index do |sx, i|
  sums.each_with_index do |sy, j|
    next if i == j

    mags << magnitude(reduce(sum(sx, sy)))
  end
end
puts mags.max
