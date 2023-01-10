package main

import (
  "fmt"
  "github.com/ns3777k/go-shodan/shodan"
  "github.com/undiabler/golang-whois"
)

type response struct{
  success bool
  url string
  eyewitness string
  shodan string
  whois string
}

func main() { 
	fmt.Println("Welcome to Threatscraper")
  
  // Get array of urls
  file, err := os.Open("url.txt")
  if err != nil {
    log.Fatalf("failed to open")
  }

  scanner:= bufio.NewScanner(file)

  scanner.Split(bufio.ScanLines)
  var urls []string

  for scanner.Scan() {
        text = append(text, scanner.Text())
    }
  
  file.Close()

  for _, each_ln := range text {
      fmt.Println(each_ln)
  }

  // Go routine to generate a struct

}

func scanUrl(url) response {

}

// Takes a URL and runs eyewitness against it
func eyewitness(url){

  program := "./eyewitness"
  args1 :=
  args2 :=
  args3 :=

  exce :=
}

func shodan(url) {

}

func whois(url) string {
  result, err := whois.GetWhois(url)
  if err != nil {
    fmt.Println("Error when looking up: %v ", err)
  }
  return result
}

