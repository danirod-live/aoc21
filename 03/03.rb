lines = File.read('input.txt').split

def mas_comun(lista, i, fb = 1)
  ceros = 0
  unos = 0
  lista.each do |l|
    if l[i] == '0'
      ceros += 1
    else
      unos += 1
    end
  end
  unos >= ceros
  if ceros == unos
    fb
  else
    ceros > unos ? 0 : 1
  end
end

def todec(line)
  i = 0
  line.chars.each do |c|
    i = i * 2 + (c == '0' ? 0 : 1)
  end
  i
end

gamma = 0
epsilon = 0
12.times do |i|
  most_common = mas_comun(lines, i)
  less_common = most_common == 0 ? 1 : 0
  gamma = gamma * 2 + most_common
  epsilon = epsilon * 2 + less_common
end
puts gamma * epsilon

oxi = lines
i = 0
while oxi.length > 1
  most_common = mas_comun(oxi, i, 1)
  oxi = oxi.filter { |l| l[i] == (most_common.zero? ? '0' : '1') }
  i += 1
end

co2 = lines
j = 0
while co2.length > 1
  most_common = mas_comun(co2, j, 1)
  co2 = co2.filter { |l| l[j] == (most_common.zero? ? '1' : '0') }
  j += 1
end

puts todec(oxi[0]) * todec(co2[0])
