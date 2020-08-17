package servicea

import (
	"fmt"
	"github.com/ZEPL/kit/version"
)

func main() {
	version := version.Get()
	fmt.Printf("Service A Got Commit %s", version.GitCommit)
}