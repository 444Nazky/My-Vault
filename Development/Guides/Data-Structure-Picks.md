# Data Structure Picks

Standalone note. No links in or out.

## Quick Map

- Lookup by key: hash map. Ordered keys: tree map or sorted vec.
- Queue FIFO: deque. Stack LIFO: vec as stack.
- Dedup members: hash set. Top K: binary heap.
- Prefix search: trie. Range count: Fenwick or segment tree.
- Graph walk: adjacency list, BFS queue, DFS stack.

## Cost Table

| Structure | Get | Insert | Ordered |
|-----------|-----|--------|---------|
| Hash map | O(1) | O(1) | no |
| Tree map | O(log n) | O(log n) | yes |
| Vec push back | O(1) | O(1) amortized | insertion |
| Heap push pop | O(1) peek | O(log n) | partial |
| Trie insert | O(key len) | O(key len) | lexicographic |

## Rules of Thumb

- Default to hash map plus vec, reach for trees only with range queries.
- Small n under a hundred: linear scan beats fancy structures.
- Cache matters more than Big-O past a point, prefer flat arrays.
- Delete-heavy plus order: check what your stdlib actually offers first.

## Gotchas

- Hash DoS on untrusted keys, use randomized hashing.
- Iterating a map while mutating it invalidates iterators in most languages.
- Floats as map keys invite epsilon pain, scale to ints when possible.

Tags: #datastructures #algorithms #programming
