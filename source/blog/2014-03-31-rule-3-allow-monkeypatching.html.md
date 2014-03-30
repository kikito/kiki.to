---
title: 'Rule #3: Allow monkeypatching'
draft: true
---

I've seen a worrying pattern in some libraries, where they add a metatable at the end to "protect the user from modifying the library".

``` lua
local mymodule = {}

... -- add functions to module

setmetatable(mymodule, {
  __newindex = function()
    error('Who dares to alter my precious module! Shame on you, worm!')
  end
})

return mymodule
```

Or something of this sort.

Don't do that.

Users should be able to modify your library if so they wish. Plus, I refer you to rule number 1 - Lua does not "protect" their modules, and neither should you.

Note that this has other ramifications. In particular, optimization by means of local functions might make modifying the library from outside more difficult than it should. Consider this case:

``` lua
local mymodule = {}

local sum = function(a,b) return a+b end
local mult = function(a,b)
  local result = 0
  for i=1,b do result = sum(result, a) end
  return result
end

mymodule.sum = sum
mymodule.mult = mult

return mymodule
```

This is a very simple example of a module that implement addition and multiplication.

Notice how `mult` holds a reference to the local variable `sum`, instead of using `mymodule.sum`. While it is faster, it presents an issue: If I was the user of this module, I would expect this to return true:

``` lua
local mymodule = require 'mymodule'

-- override mymodule.sum
mymodule.sum = function(a,b) return 1 end

print(mymodule.mult(5,2) == 5)
```

However, `mymodule.mult(5,2)` still returns `10`, even after I have overriden `mymodule.sum`. So I am forced to modify both functions, or edit the source module (which might be deep inside the luarocks folder).

I consider customizability by the user more important than a marginal speed gain. Unless the use of a local internal reference is justified, I recommend you that you don't *localize* the references to
public methods (private methods, on the other hand, are fair game - localize those to your heart's content).

