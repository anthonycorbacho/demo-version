package main

import (
	"fmt"
	"github.com/ZEPL/kit/version"
)

func main() {
	v := version.Get()
	fmt.Printf("Service A Got Commit %s\n", v.GitCommit)
}