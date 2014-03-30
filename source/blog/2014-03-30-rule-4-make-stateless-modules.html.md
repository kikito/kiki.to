---
title: 'Rule #4: Make stateless modules'
published: false
---

I have been particularly guilty of this breaking this rule in the past.

For those who don't know what it means: All the methods of the module with should return the same value when called with the same parameters. If the module is "remembering" things and altering the results of a function
call with the same parameters, then it is storing state somewhere.

Here's an example of a state-storing module:

``` lua
local dict = {}

local values = {}

dict.set = function(key, value)
  values[key] = value
end

dict.get = function(key)
  return values[key]
end

return dict
```

