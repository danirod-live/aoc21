def instruction(line)
  onoff, area = line.split(' ')
  onoff = onoff == 'on'
  xmin, xmax = area.match(/x=(-?\d+)..(-?\d+)/)[1..2].map(&:to_i)
  ymin, ymax = area.match(/y=(-?\d+)..(-?\d+)/)[1..2].map(&:to_i)
  zmin, zmax = area.match(/z=(-?\d+)..(-?\d+)/)[1..2].map(&:to_i)
  [[xmin, ymin, zmin], [xmax, ymax, zmax], onoff]
end

def instructions(file)
  File.read(file).lines.map(&:strip).map { |i| instruction(i) }
end

def interseccionar(cube, inst); end

def cubo(inst)
  min, max, onoff = inst
  { min: min, max: max, onoff: onoff, children: [] }
end

def solapan?(pmin, pmax, qmin, qmax)
  px1, py1, pz1 = pmin
  px2, py2, pz2 = pmax
  qx1, qy1, qz1 = qmin
  qx2, qy2, qz2 = qmax
  x = [px1, px2, qx1, qx2]
  y = [py1, py2, qy1, qy2]
  z = [pz1, pz2, qz1, qz2]
  [x, y, z].each do |coord|
    p1, p2, q1, q2 = coord
    return false if q1 > p2 || q2 < p1
  end
  true
end

def interseccion(pmin, pmax, qmin, qmax)
  px1, py1, pz1 = pmin
  px2, py2, pz2 = pmax
  qx1, qy1, qz1 = qmin
  qx2, qy2, qz2 = qmax
  x1 = [px1, qx1].max
  x2 = [px2, qx2].min
  y1 = [py1, qy1].max
  y2 = [py2, qy2].min
  z1 = [pz1, qz1].max
  z2 = [pz2, qz2].min
  [[x1, y1, z1], [x2, y2, z2]]
end

def interseccionar(this, inst)
  inst_min, inst_max, = inst
  return unless solapan?(this[:min], this[:max], inst_min, inst_max)

  inter_min, inter_max = interseccion(this[:min], this[:max], inst_min, inst_max)
  this[:children].each do |child|
    interseccionar(child, inst)
  end
  this[:children] << cubo([inter_min, inter_max, !this[:onoff]])
end

def step(cubos, inst)
  next_cubos = []
  cubos.each do |old_cube|
    interseccionar(old_cube, inst)
    next_cubos << old_cube
  end
  next_cubos << cubo(inst) if inst[2]
  next_cubos
end

def area(cubo)
  x1, y1, z1 = cubo[:min]
  x2, y2, z2 = cubo[:max]
  mi_area = (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  cubo[:children].each do |child|
    mi_area -= area(child)
  end
  mi_area
end

cubos = []
instructions('input.txt').each do |inst|
  coords = [inst[0], inst[1]].flatten
  next if coords.any? { |c| c < -50 || c > 50 }

  cubos = step(cubos, inst)
end
puts cubos.map { |c| area(c) }.sum

cubos = []
instructions('input.txt').each do |inst|
  cubos = step(cubos, inst)
end
puts cubos.map { |c| area(c) }.sum
