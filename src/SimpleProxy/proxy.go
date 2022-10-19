package main
// A simple script intended to form a simple port 80 TCP proxy
func handle(src net.Conn){
  dst, err := net.Dial("tcp", "target.example.com:80")
  if err != nil {
    log.Fatalln("Unable to connect to our unreachable host")
  }
  defer dst.Close()

  go func(){
    if _, err := io.Copy(dst, src); err != nil {
    log.Fatalln(err)
    }

    if _,err := io.Copy(src, dst); err != nil {
    log.Fatalln(err)
    }
  }

  func main() {

    listener, err := net.Listen("tcp", ":80")
    if err != nil{
      log,Fatalln("Unable to bind to port")
    }

    for{
      conn, err := listener.Accept()
      if err != nil {
      log.Fatalln("Unable to accept connection")
      }
      go handle(conn)
    }
}
