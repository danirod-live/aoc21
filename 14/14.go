package main

import "fmt"
import "os"
import "strings"

func expand(input string) map[string]int {
	pairs := make(map[string]int)
	for i := 0; i < len(input)-1; i++ {
		tuple := fmt.Sprintf("%c%c", input[i], input[i+1])
		value, ok := pairs[tuple]
		if ok {
			pairs[tuple] = value + 1
		} else {
			pairs[tuple] = 1
		}
	}
	return pairs
}

func next(prev map[string]int, rules map[string]string) map[string]int {
	next := make(map[string]int)
	for tuple, count := range prev {
		middle := rules[tuple]
		left := fmt.Sprintf("%c%s", tuple[0], middle)
		right := fmt.Sprintf("%s%c", middle, tuple[1])
		value, ok := next[left]
		if ok {
			next[left] = value + count
		} else {
			next[left] = count
		}
		value, ok = next[right]
		if ok {
			next[right] = value + count
		} else {
			next[right] = count
		}
	}
	return next
}

func count(prev map[string]int, trail byte) map[string]int {
	count := make(map[string]int)
	for key, value := range prev {
		letter := fmt.Sprintf("%c", key[0])
		if _, ok := count[letter]; !ok {
			count[letter] = 0
		}
		count[letter] += value
	}
	trailing := fmt.Sprintf("%c", trail)
	count[trailing]++
	return count
}

func iterate(template string, rules map[string]string, it int) int64 {
	var min int64 = -1
	var max int64 = -1

	expansion := expand(template)
	for i := 0; i < it; i++ {
		expansion = next(expansion, rules)
	}
	cnt := count(expansion, template[len(template)-1])
	for _, v := range cnt {
		bigV := int64(v)
		if min == -1 {
			min = bigV
		} else if bigV < min {
			min = bigV
		}
		if max == -1 {
			max = bigV
		} else if bigV > max {
			max = bigV
		}
	}
	return max - min
}

func parsear(file string) (string, map[string]string) {
	rules := make(map[string]string)

	data, _ := os.ReadFile(file)
	clean := string(data[:])
	lines := strings.Split(strings.TrimSuffix(clean, "\n"), "\n")
	template := lines[0]
	for i := 2; i < len(lines); i++ {
		tokens := strings.Split(lines[i], " -> ")
		rules[tokens[0]] = tokens[1]
	}
	return template, rules
}

func main() {
	template, rules := parsear("input.txt")
	result1 := iterate(template, rules, 10)
	fmt.Printf("%v\n", result1)
	result2 := iterate(template, rules, 40)
	fmt.Printf("%v\n", result2)
}
