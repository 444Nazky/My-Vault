# CSharp Cheatsheet

**Companion:** [[CSharp]] for deeper notes

## Skeleton

```csharp
Console.WriteLine("hello");
```

## Dotnet Commands

```bash
dotnet new console -n App
dotnet run --project App
dotnet build
dotnet test
```

## Types and Nullable

```csharp
int i = 42; double d = 3.14; bool b = true;
string s = "hi"; char c = 'a';
int? maybe = null; // nullable value
string? name = null; // nullable reference
int v = maybe ?? 0; // default when null
```

## Control Flow

```csharp
if (x > 0) { } else { }
for (int k = 0; k < n; k++) { }
foreach (var e in list) { }
while (cond) { }
switch (x) { case 1: break; default: break; }
```

## Class and Properties

```csharp
public class Task {
 public string Title { get; set; } = "";
 public bool Done { get; private set; }
 public void Complete() => Done = true;
}
var t = new Task { Title = "ship" };
```

## Collections

```csharp
var list = new List<int> { 3, 1, 2 };
var dict = new Dictionary<string, int> { ["a"] = 1 };
dict["b"] = 2;
```

## LINQ

```csharp
var evens = list.Where(e => e % 2 == 0).OrderBy(e => e).ToList();
var names = users.Select(u => u.Name).ToList();
var first = list.FirstOrDefault(e => e > 2);
```

## Async

```csharp
async Task<string> FetchAsync(HttpClient c, string url) {
 return await c.GetStringAsync(url);
}
await FetchAsync(client, url);
```

## Exceptions and Using

```csharp
try { File.ReadAllText("a.txt"); }
catch (IOException e) { Console.WriteLine(e.Message); }
using var f = File.OpenRead("a.txt"); // disposed at scope end
```

## String Interpolation

```csharp
var msg = $"hello {name}, count {list.Count}";
string.Join(", ", names);
```

## Gotchas

- `==` on strings compares values, on classes compares reference.
- Value types copy, reference types share.
- Always `await`, never block with `.Result` in apps.
- `IDisposable` needs `using`.

Tags: #csharp #cheatsheet #managed
