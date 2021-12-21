# frozen_string_literal: true

def problem1(p1, p2)
  positions = [p1, p2]
  score = [0, 0]
  dice = 1
  nextp = 0
  total = 0
  while score.max < 1000
    movement = dice + (dice + 1) + (dice + 2)
    positions[nextp] += movement
    positions[nextp] -= 10 while positions[nextp] > 10
    score[nextp] += positions[nextp]

    dice += 3
    dice -= 100 while dice > 100
    nextp = nextp.zero? ? 1 : 0

    total += 3
  end

  puts "#{total}=total, scores=#{score}"
  score.min * total
end

class Solver
  def initialize(win, lose)
    @win = win
    @lose = lose
    @cache = {}
  end

  def lanzar_dados(pos1, pos2, score1, score2, me_toca, dados = [])
    if dados.length == 3
      result = dados.sum
      if me_toca
        pos1 += result
        pos1 -= 10 while pos1 > 10
        score1 += pos1
      else
        pos2 += result
        pos2 -= 10 while pos2 > 10
        score2 += pos2
      end
      me_toca = !me_toca
      cuantas_gano?(pos1, pos2, score1, score2, me_toca)
    else
      (1..3).map do |lanzamiento|
        lanzar_dados(pos1, pos2, score1, score2, me_toca, dados + [lanzamiento])
      end.sum
    end
  end

  def cuantas_gano?(pos1, pos2, score1, score2, me_toca)
    key = [pos1, pos2, score1, score2, me_toca ? 'T' : 'F'].join(',')
    @cache[key] ||= if score1 >= 21
                      @win
                    elsif score2 >= 21
                      @lose
                    else
                      lanzar_dados(pos1, pos2, score1, score2, me_toca)
                    end
  end
end

def problem2(p1, p2)
  win_solver = Solver.new(1, 0)
  win = win_solver.cuantas_gano?(p1, p2, 0, 0, true)

  lose_solver = Solver.new(0, 1)
  lose = lose_solver.cuantas_gano?(p1, p2, 0, 0, true)

  [win, lose].max
end

# puts problem1(4, 8)
puts problem1(9, 6)
puts problem2(9, 6)
