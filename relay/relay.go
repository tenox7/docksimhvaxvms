// relay accepts connections on public ports and re-dials the target
// from a privileged source port (512-1023). rshd/rlogind require the
// client source port to be privileged, but docker desktop's proxy
// replaces it with an ephemeral one. simh slirp preserves source
// ports, so relaying inside the container restores the requirement.
package main

import (
	"errors"
	"io"
	"log"
	"net"
	"os"
	"strings"
	"sync"
	"syscall"
	"time"
)

var (
	mu   sync.Mutex
	next = 1023
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("usage: relay listenport=host:port ...")
	}
	var wg sync.WaitGroup
	for _, arg := range os.Args[1:] {
		lport, target, ok := strings.Cut(arg, "=")
		if !ok {
			log.Fatalf("invalid mapping %q", arg)
		}
		wg.Add(1)
		go func() {
			defer wg.Done()
			serve(lport, target)
		}()
	}
	wg.Wait()
}

func serve(lport, target string) {
	ln, err := net.Listen("tcp", ":"+lport)
	if err != nil {
		log.Fatalf("listen :%s: %v", lport, err)
	}
	log.Printf("relaying :%s -> %s", lport, target)
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Printf("accept :%s: %v", lport, err)
			continue
		}
		go relay(conn.(*net.TCPConn), target)
	}
}

func relay(client *net.TCPConn, target string) {
	server, err := dialPrivileged(target)
	if err != nil {
		log.Printf("%s -> %s: %v", client.RemoteAddr(), target, err)
		client.Close()
		return
	}
	log.Printf("%s -> %s via %s", client.RemoteAddr(), target, server.LocalAddr())
	pipe(client, server)
}

func pipe(a, b *net.TCPConn) {
	var wg sync.WaitGroup
	half := func(dst, src *net.TCPConn) {
		defer wg.Done()
		io.Copy(dst, src)
		dst.CloseWrite()
	}
	wg.Add(2)
	go half(a, b)
	go half(b, a)
	wg.Wait()
	a.Close()
	b.Close()
}

func dialPrivileged(target string) (*net.TCPConn, error) {
	d := net.Dialer{
		Timeout: 10 * time.Second,
		Control: func(network, address string, c syscall.RawConn) error {
			return c.Control(func(fd uintptr) {
				syscall.SetsockoptInt(int(fd), syscall.SOL_SOCKET, syscall.SO_REUSEADDR, 1)
			})
		},
	}
	for range 512 {
		d.LocalAddr = &net.TCPAddr{Port: reservePort()}
		conn, err := d.Dial("tcp", target)
		if err == nil {
			return conn.(*net.TCPConn), nil
		}
		if errors.Is(err, syscall.EADDRINUSE) || errors.Is(err, syscall.EADDRNOTAVAIL) {
			continue
		}
		return nil, err
	}
	return nil, errors.New("no privileged source port available")
}

func reservePort() int {
	mu.Lock()
	defer mu.Unlock()
	p := next
	next--
	if next < 512 {
		next = 1023
	}
	return p
}
