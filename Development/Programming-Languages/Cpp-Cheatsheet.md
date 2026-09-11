# Cpp Cheatsheet

**Part of:** [[Programming-Languages-Cobweb]]
**Companion:** [[Cpp]] for deeper notes

## Skeleton

```cpp
#include <iostream>
int main() {
    std::cout << "hello\n";
    return 0;
}
```

## Build and Run

```bash
g++ main.cpp -o main -std=c++20 -Wall -Wextra
./main
```

## IO

```cpp
int x; std::cin >> x;
std::cout << x << '\n';
std::string s; std::getline(std::cin, s);
```

## References and Auto

```cpp
int v = 1, &r = v;      // r aliases v
const auto& cr = v;     // read-only view, preferred in loops
auto n = 42;            // deduced int
```

## Class Basics

```cpp
struct Point { int x = 0, y = 0; };   // public by default
class Bank {
    double bal = 0;                   // private by default
public:
    Bank(double b) : bal(b) {}        // constructor
    void deposit(double d) { bal += d; }
};
```

## Smart Pointers

```cpp
#include <memory>
auto u = std::make_unique<int>(5);    // single owner
auto s = std::make_shared<int>(5);    // shared owner
std::weak_ptr<int> w = s;             // breaks cycles
```

## STL Containers

```cpp
#include <vector>
#include <string>
#include <map>
std::vector<int> v = {3, 1, 2};
v.push_back(4);
for (int e : v) { }
std::map<std::string,int> m = {{"a", 1}};
m["b"] = 2;
```

## Algorithms

```cpp
#include <algorithm>
std::sort(v.begin(), v.end());
auto it = std::find(v.begin(), v.end(), 2);
std::transform(v.begin(), v.end(), v.begin(), [](int e){ return e * 2; });
```

## Templates

```cpp
template <typename T>
T max2(T a, T b) { return a > b ? a : b; }
```

## Exceptions

```cpp
try { throw std::runtime_error("bad"); }
catch (const std::exception& e) { }
```

## Gotchas

- Rule of 3 slash 5 slash 0 for classes owning resources.
- Pass by const ref, return by value.
- `vector<bool>` is special, avoid it.
- Prefer `unique_ptr`, reach for `shared_ptr` only when shared.

Tags: #programming #cpp #cheatsheet
