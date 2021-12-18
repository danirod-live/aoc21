package main

import "os"
import "fmt"
import "strings"
import "strconv"

func readgrid(file string) [][]int {
	data, _ := os.ReadFile(file)
	clean := string(data[:])
	lines := strings.Split(strings.TrimSuffix(clean, "\n"), "\n")
	grid := [][]int{}
	for _, line := range lines {
		line := strings.Split(line, "")
		gridline := []int{}
		for _, num := range line {
			clean_num, _ := strconv.Atoi(num)
			gridline = append(gridline, clean_num)
		}
		grid = append(grid, gridline)
	}
	return grid
}

type grilla [][]int
type posicion [2]int

func expand(data grilla) grilla {
	new_data := [][]int{}
	for i := 0; i < 5; i++ {
		for _, row := range data {
			new_row := []int{}
			for j := 0; j < 5; j++ {
				for _, value := range row {
					new_value := value + i + j
					if new_value > 9 {
						new_value -= 9
					}
					new_row = append(new_row, new_value)
				}
			}
			new_data = append(new_data, new_row)
		}
	}
	return new_data
}

func minimum_unvisited_tentative(cands map[posicion]int) posicion {
	var min_key posicion
	var min_value int
	min_value = 9999999999

	for key, value := range cands {
		if value < min_value {
			min_key = key
			min_value = value
		}
	}
	return min_key
}

func dijkstra(data grilla) int {
	width := len(data[0])
	height := len(data)

	// unvisited is a map that acts as a set. i only care about keys
	// this is the set of unvisited nodes that we need to inspect
	unvisited := make(map[posicion]bool)

	// tentatives is a grid where the position [y][x] contains the
	// tentative cost of going from 0,0 to y,x in our grid map
	tentatives := [][]int{}

	// unvisited_with_tentatives is a subset of unvisited, but
	// only contains keys that have a valid (positive) value for
	// the tentatives
	unvisited_with_tentatives := make(map[posicion]int)

	for y := 0; y < height; y++ {
		row := []int{}
		for x := 0; x < width; x++ {
			unvisited[[2]int{x,y}] = true
			row = append(row, -1)
		}
		tentatives = append(tentatives, row)
	}

	tentatives[0][0] = 0
	unvisited_with_tentatives[[2]int{0, 0}] = 0

	for len(unvisited) > 0 {
		if len(unvisited) % 1000 == 0 {
			fmt.Printf("[ %v items left...] \n", len(unvisited))
		}
		next := minimum_unvisited_tentative(unvisited_with_tentatives)
		delete(unvisited, next)
		delete(unvisited_with_tentatives, next)

		x := next[0]
		y := next[1]
		ne := [4]posicion{
			[2]int{x + 1, y},
			[2]int{x - 1, y},
			[2]int{x, y + 1},
			[2]int{x, y - 1},
		}
		for _, n := range ne {
			if _, ok := unvisited[n]; ok {
				nx := n[0]
				ny := n[1]
				posible := tentatives[y][x] + data[ny][nx]
				current := tentatives[ny][nx]
				if current == -1 || posible < current {
					tentatives[ny][nx] = posible
					unvisited_with_tentatives[n] = posible
				}
			}
		}
	}

	return tentatives[height - 1][width - 1]
}

func main() {
	grid := readgrid("input.txt")
	value := dijkstra(grid)
	fmt.Printf("%d \n", value)

	grid = expand(grid)
	value = dijkstra(grid)
	fmt.Printf("%d \n", value)
}
