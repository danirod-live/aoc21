data = File.read('input.txt').lines
adjacents = {}
data.each do |line|
  from, to = line.strip.split('-')
  adjacents[from] = [] unless adjacents[from]
  adjacents[to] = [] unless adjacents[to]
  adjacents[from] << to
  adjacents[to] << from
end

def caminos(here, adjacents, visited)
  return 1 if here == 'end'

  choices = adjacents[here]
  choices.map do |choice|
    if choice.downcase == choice && visited.include?(choice)
      0
    else
      caminos(choice, adjacents, visited + [here])
    end
  end.sum
end

def caminos2(here, adjacents, visited, comodin)
  return 1 if here == 'end'

  choices = adjacents[here]
  next_visit = visited + [here]
  choices.map do |choice|
    grande = choice.upcase == choice
    next caminos2(choice, adjacents, next_visit, comodin) if grande || !visited.include?(choice)

    if !comodin && choice != 'start' && choice != 'end'
      caminos2(choice, adjacents, next_visit, true)
    else
      0
    end
  end.sum
end

puts caminos('start', adjacents, [])
puts caminos2('start', adjacents, [], false)
