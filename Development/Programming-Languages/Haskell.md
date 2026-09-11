# Haskell Notes

**Born:** 1990. Pure functional, lazy, types that prove behavior.

## Purity Means No Surprises

```haskell
double :: Int -> Int
double x = x * 2
```

Same input always gives same output. Effects live in IO and friends.

## Maybe Replaces Null

```haskell
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x
```

## Gotchas

- Laziness delays work until needed, space leaks hide in thunks.
- Strings are linked lists of Char, use Text for real work.
- Typeclasses are interfaces with laws, read the laws.
- Start every function with a type signature or inference gets cryptic.

**Mental model:** functions plus types plus managed effects.

Tags: #programming #haskell #cobweb
