package serviceb

import (
	"fmt"
	"github.com/ZEPL/kit/version"
)

func main() {
	version := version.Get()
	fmt.Printf("Service B Got Commit %s", version.GitCommit)
}