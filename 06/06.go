package main

import (
	"os"
	"fmt"
	"math"
	"strings"
	"strconv"
)

func children(state int, maxdays int) int {
	maxdays_when_reproduce := maxdays - state - 1
	children_this := int(math.Ceil(float64(maxdays - state) / 7))
	if children_this < 0 {
		children_this = 0
	}
	total := children_this
	for {
		if maxdays_when_reproduce <= 0 {
			return total
		}
		total += children(8, maxdays_when_reproduce)
		maxdays_when_reproduce -= 7
	}
}

func main() {
	data, _ := os.ReadFile("input.txt")
	clean := string(data[:])
	clean = strings.TrimSuffix(clean, "\n")
	fish := strings.Split(clean, ",")
	total := 0
	cache := make(map[int]int)
	for _, f := range fish {
		cleanf, err := strconv.Atoi(f)
		if cleanf > 0 || err == nil { // Todo: probably I should check err != nil instead of cleanf == 0
			fmt.Printf(".")
			total += 1
			if res, ok := cache[cleanf]; ok {
				total += res
			} else {
				this := children(cleanf, 256)
				cache[cleanf] = this
				total += this
			}
		}
	}
	fmt.Printf("\n%v\n", total)
}

