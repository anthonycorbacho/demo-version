package main

import (
	"fmt"
	"github.com/ZEPL/kit/version"
)

func main() {
	v := version.Get()
	fmt.Printf("Service B Git Commit %s", v.GitCommit)
}