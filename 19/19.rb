def read(file)
  lines = File.read(file).split("\n\n")
  lines.map do |block|
    block.lines.drop(1).map { |line| line.split(',').map(&:to_i) }
  end
end

def transformar(vector)
  x, y, z = vector

  rotaciones = [
    [x, y, z],
    [z, y, -x],
    [-z, y, x],
    [-x, y, -z],
    [x, -z, y],
    [x, z, -y]
  ]

  spins = []
  rotaciones.each do |rx, ry, rz|
    spins << [rx, ry, rz]
    spins << [ry, -rx, rz]
    spins << [-rx, -ry, rz]
    spins << [-ry, rx, rz]
  end
  spins
end

def try_merge(left, right)
  left.each_with_index do |l, _i|
    right.each_with_index do |r, _j|
      dx = r[0] - l[0]
      dy = r[1] - l[1]
      dz = r[2] - l[2]
      trasposed_right = right.map { |rx, ry, rz| [rx - dx, ry - dy, rz - dz] }
      common = left.intersection(trasposed_right)

      next unless common.length >= 12

      return left.union(trasposed_right)
    end
  end

  nil
end

def sistemas(scanner)
  rotaciones = Array.new(24) { [] }

  spins = scanner.map { |vector| transformar(vector) }
  24.times.each do |spin|
    scanner.length.times.each do |i|
      rotaciones[spin] << spins[i][spin]
    end
  end

  rotaciones
end

def big_step(ref, remain)
  puts "Quedan #{remain.length}..."
  remain.each_with_index do |scanner, i|
    sistemas(scanner).each do |sistema|
      result = try_merge(ref, sistema)
      next if result.nil?

      remain.delete_at(i)
      return result
    end
  end
end

scanners = read('input.txt')
ref, *remain = scanners

ref = big_step(ref, remain) while remain.length.positive?

puts ref.uniq.count
