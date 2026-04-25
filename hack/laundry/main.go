package main

import (
	"fmt"
	"log"
	"os/user"
	"sync"

	s "github.com/bitfield/script"
)

var logFilePath = "/var/log/laundry.log"

func main() {
	u, err := user.Current()
	if err != nil {
		log.Fatal(err)
	}
	if u.Uid != "0" {
		log.Fatalf("You must be running as root")
	}
	// These should all be safe to run concurrently
	wg := sync.WaitGroup{}
	for _, command := range []string{
		"docker image prune -af",
		"docker container prune -f",
		"nix-collect-garbage -d"} {
		s.Echo(fmt.Sprintf("Doing : %s\n", command)).AppendFile(logFilePath)
		s.Exec(command).AppendFile(logFilePath)
		s.Echo("Done\n").AppendFile(logFilePath)
	}
	wg.Wait()
}
