# Go Cheatsheet

**Companion:** [[Go]] for deeper notes

## Skeleton

```go
package main

import "fmt"

func main() {
 fmt.Println("hello")
}
```

## Module Commands

```bash
go mod init app
go run .
go build -o app .
go test ./...
go fmt ./...
```

## Variables and Types

```go
var i int = 42
s := "hi" // shorthand, funcs only
const Pi = 3.14
var arr [3]int
sl := []int{1, 2, 3}
m := map[string]int{"a": 1}
```

## Control Flow

```go
if x > 0 { } else { }
for k := 0; k < n; k++ { }
for _, e := range sl { }
switch x { case 1: fmt.Println("one"); default: }
```

## Functions Multi Return

```go
func div(a, b int) (int, error) {
 if b == 0 { return 0, errors.New("zero") }
 return a / b, nil
}
```

## Struct and Methods

```go
type User struct{ Name string; Age int }
func (u User) Greet() string { return "hi " + u.Name }
```

## Interfaces

```go
type Shaper interface{ Area() float64 }
func big(s Shaper) bool { return s.Area() > 100 }
```

## Concurrency

```go
ch := make(chan int, 2) // buffered
go worker(ch)
v := <-ch
close(ch)
```

## Defer and Panic

```go
defer f.Close()
if r := recover(); r != nil { } // inside deferred func
```

## Gotchas

- Handle every error return, even with `_` consciously.
- Copy slices with `copy`, appending may reallocate.
- Time format uses the reference date `2006-01-02 15:04:05`.
- JSON tags steer marshaling: `json:"name"`.

Tags: #go #cheatsheet #systems
