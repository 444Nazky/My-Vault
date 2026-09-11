# C Cheatsheet

**Companion:** [[C]] for deeper notes

## Skeleton

```c
#include <stdio.h>

int main(void) {
 printf("hello\n");
 return 0;
}
```

## Build and Run

```bash
gcc main.c -o main -Wall -Wextra # warn a lot
./main
gcc -g main.c -o dbg # debug symbols for gdb
```

## Types

```c
char c = 'a'; // 1 byte
int i = 42; // usually 4 bytes
long l = 100000L;
float f = 1.5f;
double d = 3.14;
unsigned int u = 7;
size_t n = sizeof(i); // for sizes, print with %zu
```

## Printf and Scanf Formats

```c
printf("%d %u %ld %f %.2f %c %s %p %%\n", i, u, l, f, f, c, "str", (void*)&i);
scanf("%d", &i); // needs & except for %s into a buffer
```

## Control Flow

```c
if (x > 0) { } else if (x == 0) { } else { }
for (int k = 0; k < n; k++) { }
while (cond) { }
do { } while (cond);
switch (x) { case 1: break; default: break; }
```

## Functions

```c
int add(int a, int b) { return a + b; }
// declaration in header, definition in .c file
```

## Pointers and Arrays

```c
int x = 5, *p = &x;
*p = 6; // x is now 6
int a[3] = {1, 2, 3};
int *q = a; // arrays decay to pointers
a[1] == *(a + 1); // same thing
```

## Strings

```c
#include <string.h>
char s[64] = "hi";
strcpy(s, "hello"); // dest must be big enough
strlen(s); strcmp(a, b); // 0 means equal
```

## Struct

```c
typedef struct { char name[32]; int age; } Person;
Person p = {"ana", 30};
Person *pp = &p;
pp->age = 31;
```

## Heap Memory

```c
#include <stdlib.h>
int *buf = malloc(10 * sizeof *buf);
if (!buf) return 1;
free(buf); buf = NULL; // free once, null it
```

## File IO

```c
FILE *f = fopen("a.txt", "r");
char line[256];
while (fgets(line, sizeof line, f)) { }
fclose(f);
```

## Gotchas

- `=` assigns, `==` compares. `strcmp` returns 0 on equal.
- Uninitialized locals hold garbage. Globals start at zero.
- `sizeof` on a function parameter array gives pointer size.
- Signed overflow is undefined. Free memory exactly once.

Tags: #c #cheatsheet #systems
