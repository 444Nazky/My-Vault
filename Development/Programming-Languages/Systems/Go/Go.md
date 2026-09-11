# Go Notes

**Born:** 2009. Simple servers and CLIs, GC, CSP concurrency.

## Goroutines in 30 Seconds

```go
ch := make(chan string)
go func() { ch <- "done" }()
msg := <-ch
println(msg)
```

Cheap threads multiplexed on OS threads. Share via channels, not locks.

## Slices Grow, Arrays Do Not

```go
a := [3]int{1, 2, 3} // fixed array
s := []int{1, 2} // slice, grows
s = append(s, 3)
```

## Defer Runs at Return

```go
f, _ := os.Open("a.txt")
defer f.Close() // runs when function returns
```

## Gotchas

- Unused imports and variables are compile errors.
- Nil maps read fine but panic on write, make them first.
- `:=` only inside functions, `var` at package level.
- Errors are values, check every one.

**Mental model:** simple syntax plus goroutines plus fast builds.

Tags: #go #cobweb #systems
