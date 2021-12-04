numeros, _, *intableros = File.read('input.txt').lines

numeros = numeros.split(',')

def state_won?(state)
  trasp = 5.times.map { |j| 5.times.map { |i| state[i][j] } }
  state.any?(&:all?) || trasp.any?(&:all?)
end

tableros = []
states = []
count = 0
while intableros.length.positive?
  l1, l2, l3, l4, l5, _empty, *intableros = intableros
  tablero = [l1.split, l2.split, l3.split, l4.split, l5.split]
  tableros << tablero

  state = 5.times.map { [false, false, false, false, false] }
  states << state

  count += 1
end

victorias = tableros.map { false }
numeros.each do |num|
  tableros.each_with_index do |t, p|
    next if victorias[p]

    state = states[p]
    5.times.each do |j|
      5.times.each do |i|
        state[i][j] = true if t[i][j] == num
      end
    end

    next unless state_won?(state)

    sum = 0
    5.times.each do |j|
      5.times.each do |i|
        sum += t[i][j].to_i unless state[i][j]
      end
    end
    solution = sum * num.to_i
    puts(solution) if victorias.all? { |v| v == false }
    victorias[p] = true
    puts(solution) if victorias.all?
  end
end
