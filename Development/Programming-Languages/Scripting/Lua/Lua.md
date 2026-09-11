# Lua Notes

**Born:** 1993. Tiny embeddable scripting, 1-indexed tables, powers Neovim and Hyprland lua configs.

## Tables Are Everything

```lua
local t = { 10, 20, name = "ana" }
print(t[1])       -- 10, arrays start at 1
print(t.name)     -- sugar for t["name"]
```

## Nil Deletes Keys

```lua
t.name = nil      -- key is gone, length counts the array part only
```

Used across this vault in hyprland lua and env lua configs.

## Gotchas

- Indexing starts at 1, `#t` length breaks on holes.
- Variables are global unless declared `local`, always use local.
- `~=` means not-equal, `..` concatenates strings.
- One value type for numbers (float) unless LuaJIT or 5 point 3 int subtype.

**Mental model:** tables plus first-class functions plus almost no syntax.

Tags: #programming #lua #cobweb #scripting
