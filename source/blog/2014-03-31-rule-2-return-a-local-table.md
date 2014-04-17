---
title: 'Rule #2: Return a local table'
---

This is the second rule of my [Guide to authoring Lua modules](/blog/2014/03/30/a-guide-to-authoring-lua-modules).

<!-- MORE -->

This can encompasses two different things:

* Do not use the deprecated `module` keyword - even if you are still in Lua 5.1.
* You should declare a local variable somewhere in your module, and return it at the end.

In other words, your module should be doing something similar to this:

``` lua
local mymodule = {}

... -- add functions to module

return mymodule
```

And it should be used like this:

``` lua
local mymodule = require 'module'
```

You can alter things a little (for example, it is not required that the table variable is called the same as the file - although it helps). You should not use global variables instead of returning local ones though.

## Meta fields

I also recommend adding `_VERSION`, `_DESCRIPTION`, `_LICENSE` & `_URL` fields to all modules, so the module declaration looks like this:

``` lua
local foobar = {
  _VERSION     = 'foobar v1.0.0',
  _DESCRIPTION = 'Library for transforming foo in bar',
  _URL         = 'http://foobar.page.or.repo.com',
  _LICENSE     = [[
    ... (license text, or name/url for long licenses)
  ]]
}

... -- add functions to foobar

return foobar
```

These fields are a good idea for various reasons.

`_VERSION` is kind of a standard name in Lua (there is global [`_VERSION` variable](http://www.lua.org/manual/5.2/manual.html#pdf-_VERSION)). Its main purpose is making sure that you got the right version of a library
loaded up. It answers questions like *"Is this version the development one I'm using, or an old one from LuaRocks?"*.

The rest of the fields are things that you should write at the top of your module anyway - they make for a nice header. But if you write them as module fields instead of, say, comments at the top of the file, they can help
in subtle ways. For example, if you want your users to display our library license text somewhere in your app, it will be much easier to comply with that if said text is already available in the module.

I have been using meta fields for a while now in all my libraries and I have never looked back. You can see an example in [middleclass](https://github.com/kikito/middleclass/blob/master/middleclass.lua).

## Single-function modules

If you are implementing a module that just implements one function, I think you still should return a table.

For starters, if you use a table you can use the awesome meta fields I discussed above.

In addition to that, thanks to the [`__call` metamethod](http://www.lua.org/manual/5.2/manual.html#2.4), your library can be used just as if it returned a single function.

``` lua
-- pow.lua
local pow = {
  ... --meta-fields here
}

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
print(pow.pow(2,3)) -- 8
```

You can see an example of this pattern in [inspect.lua](https://github.com/kikito/inspect.lua/blob/master/inspect.lua).

Notice that if you are going to use this technique, you *should still provide a way to access the original function* (`pow.pow` in the previous example). While minimal, using this technique has a small performance penalty.
By providing access to the raw function, you will be enabling your users to avoid that penalty if they so choose. In this case is a trivial thing to do, so you might as well do it.


## Private functions and complete module example

Most of the libraries I do require some sort of private functions, in order to avoid code repetition and increase cleanliness. I usually put private functions right after the module declaration, with the meta fields.
I also put "public" functions at the end. My modules end up looking like this:

```lua
-- 1. Module declaration (mandatory, meta fields recommended)
local greetings = {
  _VERSION     = 'greetings v1.0.0',
  _DESCRIPTION = 'An extremely servile module',
  _URL         = 'http://github.com/kikito/greetings.lua',
  _LICENSE     = [[
    ... (license text)
  ]]
}

-- 2. Private functions (when needed)
local isMyMaster(name)
  return name == 'kikito'
end

-- 3. Public functions (at least 1)
greetings.greet = function(name)
  name = name or 'stranger'
  if isMyMaster(name) then
    print("Welcome, my master")
  else
    print("Hello, " .. name)
  end
end

-- 5. Metatable (when needed)
setmetatable(greetings, {__call = function(_, name) return greetings.greet(name) end})

-- 6. Return (mandatory)
return greetings
```

## Conclusion

It took me a while to get to this structure, but I have been using it for a while now and I haven't seen any changes.

I recommend it for all new modules and refactorings of old ones - even if they are written for Lua 5.1!
