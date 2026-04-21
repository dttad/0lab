package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
	"sync"

	"golang.org/x/net/publicsuffix"
)

func main() {
	inPath := flag.String("in", "input.txt", "input file")
	outPath := flag.String("out", "output.txt", "output file")
	workers := flag.Int("w", 8, "workers")
	flag.Parse()

	in, _ := os.Open(*inPath)
	defer in.Close()

	out, _ := os.Create(*outPath)
	defer out.Close()

	jobs := make(chan string, 10000)
	results := make(chan string, 10000)

	var wg sync.WaitGroup

	// workers
	for i := 0; i < *workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for d := range jobs {
				if e, err := publicsuffix.EffectiveTLDPlusOne(d); err == nil {
					results <- e
				}
			}
		}()
	}

	// reader
	go func() {
		r := bufio.NewReader(in)
		for {
			line, err := r.ReadString('\n')
			if line != "" {
				jobs <- strings.TrimSpace(line)
			}
			if err == io.EOF {
				break
			}
		}
		close(jobs)
	}()

	// closer
	go func() {
		wg.Wait()
		close(results)
	}()

	// writer
	w := bufio.NewWriter(out)
	defer w.Flush()

	count := 0
	for r := range results {
		fmt.Fprintln(w, r)
		count++
	}

	fmt.Println("done:", count)
}
