---
title: 'Rule #2: Return a local table'
draft: true
---

This is the second rule of my [Guide to building Lua modules](/blog/2014/03/31/a-guide-to-building-lua-modules).

<!-- MORE -->

This rule means two things:

* Do not use the deprecated `module` keyword.
* You should use a local variable and return it at the end.

In other words, your module should look more or less like this:

``` lua
local mymodule = {}

... -- add functions to module

return mymodule
```

And it should be used like this:

``` lua
local mymodule = require 'module'
```

## Meta fields

I also recommend adding `__VERSION`, `__DESCRIPTION` & `__LICENSE` fields to all modules:

``` lua
local mymodule = {
  __VERSION = '1.0.0',
  __DESCRIPTION = 'Library for transforming foo in bar',
  __LICENSE = [[
    ... (license text)
  ]]
}

... -- add functions to module

return mymodule
```

(You can see an example of this in [middleclass](https://github.com/kikito/middleclass/blob/master/middleclass.lua))

This facilitates things a lot when you are developing a library and you are not sure of which version of the library you have included (the one you are developing vs the one from luarocks vs a previous one from luarocks). It also
turns out that having this information at the beginning of your file is very convenient.

## Single-function modules

If you are implementing a module that just implements one function, you still should return a table.

However, in this particular case, it's ok to use the `__call` metamethod to make the module easier to use.

``` lua

local pow = {}

pow.pow = function(a,b)
  local result = a
  for i=2,b do result = result * a end
  return result
end

setmetatable(pow, {
  __call = function(_,a,b) return pow.pow(a,b) end
})

return pow
```

Usage:

```
local pow = require 'pow'

print(pow(2,3)) -- 8
```

You can see an example of this pattern in [inspect.lua](https://github.com/kikito/inspect.lua/blob/master/inspect.lua).


