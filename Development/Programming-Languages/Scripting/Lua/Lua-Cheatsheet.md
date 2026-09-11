# Lua Cheatsheet

**Companion:** [[Lua]] for deeper notes

## Skeleton

```lua
print("hello")
```

## Run

```bash
lua main.lua
luac -p main.lua   # syntax check only
```

## Variables and Types

```lua
local i = 42; local s = "hi"; local b = true; local n = nil
local t = {}       -- table, the only compound type
```

## Strings

```lua
local msg = "hello " .. name
string.len(s); string.sub(s, 1, 2)
local count = 0
for _ in pairs(t) do count = count + 1 end
string.format("%d items", count)
```

## Control Flow

```lua
if x > 0 then
elseif x == 0 then
else
end
for k = 1, n do end
for k, v in ipairs(t) do end   -- array part
for k, v in pairs(t) do end    -- all keys
while cond do end
```

## Functions

```lua
local function add(a, b) return a + b end
local dbl = function(e) return e * 2 end
```

## Tables

```lua
local u = { name = "ana", tags = { "x", "y" } }
u.age = 30; print(u.tags[1])
table.insert(u.tags, "z")
table.sort(nums)
```

## Metatables

```lua
local mt = { __add = function(a, b) return a.v + b.v end }
setmetatable(obj, mt)
```

## Modules

```lua
-- mod.lua
local M = {}
function M.hi() return "hi" end
return M
-- main.lua
local mod = require("mod")
```

## Gotchas

- `local` everything or it leaks global.
- `pairs` order is undefined, sort keys when it matters.
- Comparing tables compares identity, not content.
- `0` and empty string are truthy, only nil and false are falsy.

Tags: #programming #lua #cheatsheet #scripting
