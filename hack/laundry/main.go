package main

import (
	"log"
	"os"
	"os/user"
	"regexp"
	"sync"

	s "github.com/bitfield/script"
)

var logFilePath = "/var/log/laundry.log"

func getUsage() string {
	rootReg := regexp.MustCompile("/$")
	str, _ := s.Exec("df -h").
		MatchRegexp(rootReg).
		Column(5).
		String()
	return str
}

func mustBeRoot() {
	u, err := user.Current()
	if err != nil {
		log.Fatal(err)
	}
	if u.Uid != "0" {
		log.Fatalf("You must be running as root")
	}
}

func main() {
	log.Println(getUsage())
	mustBeRoot()
	f, err := os.OpenFile(logFilePath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	log.SetOutput(f)
	log.Printf("Starting disk usage: %s", getUsage())

	// These should all be safe to run concurrently
	wg := sync.WaitGroup{}
	for _, command := range []string{
		"docker image prune -af",
		"docker container prune -f",
		"nix-collect-garbage -d"} {
		wg.Go(func() {
			log.Printf("Running : %s\n", command)
			stdOut, err := s.Exec(command).String()
			log.Println("Stdout:", stdOut)
			log.Printf("Errors: %v", err)
			log.Printf("Done : %s\n", command)
		})
	}
	wg.Wait()
	log.Printf("Finishing disk usage: %s", getUsage())
}
