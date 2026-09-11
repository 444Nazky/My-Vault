# Haskell Cheatsheet

**Companion:** [[Haskell]] for deeper notes

## Skeleton

```haskell
main :: IO ()
main = putStrLn "hello"
```

## Build and Run

```bash
ghc Main.hs -o app
runghc Main.hs
ghci
```

## Basics

```haskell
x = 42                  -- immutable binding
add a b = a + b
dbl = map (*2)          -- operator section
```

## Lists

```haskell
[1, 2, 3]
1 : [2, 3]              -- cons
head [1, 2]             -- 1, partial on empty
map (*2) [1, 2]
filter even [1, 2, 3]
foldl (+) 0 [1, 2]
```

## Control Flow

```haskell
f x = if x > 0 then "pos" else "neg"
g 0 = "zero"
g _ = "other"           -- pattern match, wildcard last
case x of { Just v -> v; Nothing -> 0 }
```

## Types

```haskell
data Shape = Dot | Circle Double
newtype UserId = UserId Int
type Name = String
```

## IO

```haskell
main = do
  line <- getLine
  putStrLn ("hi " ++ line)
```

## Functor Applicative Monad

```haskell
fmap (+1) (Just 2)        -- Just 3
pure 1 <*> Just 2         -- needs Applicative
Just 2 >>= (\x -> Just (x + 1))
do { a <- Just 2; return (a + 1) }
```

## Gotchas

- Indentation is syntax, misaligned do blocks fail weirdly.
- `==` needs Eq, numbers default awkwardly, annotate.
- Infinite lists are fine, printing them is not.
- Learn Hoogle, search functions by type signature.

Tags: #programming #haskell #cheatsheet #scripting
