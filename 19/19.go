package main

import "fmt"
import "os"
import "strings"
import "strconv"

type point [3]int

type scanner []point

type problem []scanner

func atoi(num string) int {
	i, err := strconv.Atoi(num)
	if err != nil {
		panic("no")
	} 
	return i
}

func parse_file(input string) problem {
	pro := []scanner{}

	data, _ := os.ReadFile(input)
	lines := strings.Split(string(data), "\n")
	i := 1
	scanner := []point{}
	for i < len(lines) {
			if lines[i] == "" {
				pro = append(pro, scanner)
				scanner = []point{}
				i += 2
			} else {
				comp := strings.Split(lines[i], ",")
				punto := [3]int{
					atoi(comp[0]),
					atoi(comp[1]),
					atoi(comp[2]),
				}
				scanner = append(scanner, punto)
				i += 1
			}
	}

	return pro
}

func makep(x, y, z int) point {
	return [3]int{x, y, z}
}

func transformar(punto point) []point {
	x := punto[0]
	y := punto[1]
	z := punto[2]

	rotaciones := []point{
		makep(x, y, z),
		makep(z, y, -x),
		makep(-z, y, x),
		makep(-x, y, -z),
		makep(x, -z, y),
		makep(x, z, -y),
	}

	spins := []point{}
	for _, rotacion := range rotaciones {
		rx := rotacion[0]
		ry := rotacion[1]
		rz := rotacion[2]
		spins = append(spins, makep(rx, ry, rz))
		spins = append(spins, makep(ry, -rx, rz))
		spins = append(spins, makep(-rx, -ry, rz))
		spins = append(spins, makep(-ry, rx, rz))
	}
	return spins
}

func trasponer(scan scanner, dx, dy, dz int) scanner {
	trasposed := []point{}
	for _, point := range scan {
		trasposed = append(trasposed, makep(point[0] - dx, point[1] - dy, point[2] - dz))
	}
	return trasposed
}

func intersection(left scanner, right scanner) scanner {
	intersection := []point{}
	common := make(map[point]bool)

	for _, l := range left {
		common[l] = true
	}
	for _, r:= range right {
		if _, ok := common[r]; ok {
			intersection = append(intersection, r)
		}
	}
	return intersection
}

func union(left scanner, right scanner) scanner {
	union := []point{}
	common := make(map[point]bool)

	for _, l := range left {
		common[l] = true
	}
	for _, r:= range right {
		common[r] = true
	}
	for k, _ := range common {
		union = append(union, k)
	}
	return union
}

func try_merge(left scanner, right scanner) (scanner, point) {
	for _, l := range left {
		for _, r := range right {
			dx := r[0] - l[0]
			dy := r[1] - l[1]
			dz := r[2] - l[2]
			trasposed_right := trasponer(right, dx, dy, dz)
			inter := intersection(left, trasposed_right)
			if len(inter) >= 12 {
				center := makep(-dx, -dy, -dz)
				return union(left, trasposed_right), center
			}
		}
	}
	return nil, makep(0, 0, 0)
}

func sistemas(scan scanner) [24]scanner {
	var rotaciones [24]scanner
	for r := 0; r < 24; r++ {
		rotaciones[r] = []point{}
	}
	spins := []scanner{}
	for _, p := range scan {
		trans := transformar(p)
		spins = append(spins, trans)
	}
	for s := 0; s < 24; s++ {
		for i := 0; i  < len(scan); i++ {
			rotaciones[s] = append(rotaciones[s], spins[i][s])
		}			
	}
	return rotaciones
}

func big_step(ref scanner, remain []scanner, centers []point) (scanner, []scanner, []point) {
	fmt.Printf("Quedan %v elementos\n", len(remain))
	for i, scanner := range remain {
		sist := sistemas(scanner)
		for _, sistema := range sist {
			result, center := try_merge(ref, sistema)
			if result != nil {
				clean_remain := append(remain[:i], remain[i+1:]...)
				return result, clean_remain, append(centers, center)
			}
		}
	}
	// can't reach here
	return nil, nil, nil
}

func print_system(r scanner) {
	for _, i := range r{
		fmt.Printf("%v\n", i)
	}
}

func main() {
	data := parse_file("input.txt")
	ref := data[0]
	remain := data[1:]
	centers := []point{makep(0, 0, 0)}
	for len(remain) > 0 {
		ref, remain, centers = big_step(ref, remain, centers)
	}
	fmt.Printf("%v\n", len(ref))

	max := 0
	for _, a := range centers {
		for _, b := range centers {
			manh := (a[0] - b[0]) + (a[1] - b[1]) + (a[2] - b[2])
			if manh > max {
				max = manh
			}
		}
	}
	fmt.Printf("%v\n", max)
}
