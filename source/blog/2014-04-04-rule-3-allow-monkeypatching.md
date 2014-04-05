---
title: 'Rule #3: Allow monkeypatching'
---

This is the third rule of my [Guide to building Lua modules](/blog/2014/03/30/a-guide-to-building-lua-modules).

<!-- MORE -->

## SpiderMonkey

[Monkeypatching](http://en.wikipedia.org/wiki/Monkey_patch) is the act of "modifiying core parts of a language or system" (read the previous wikipedia article before to learn more).

Lua is a *highly monkeypatchable language*. Consider the following example:

``` lua
math.random = function()
  return 0.5
end

print(math.random()) -- 0.5
```

This runs without throwing errors of any kind. There are some limits (you can't make `true` be `false`, for example) but Lua lets you change almost anything.

This kind of flexibility is powerful. But:

> With great power comes great responsibility

<cite><a href="http://en.wikipedia.org/wiki/Uncle_Ben">Uncle Ben</a></cite>

With monkeypatching you can do lots of interesting and subltle things. But you can also make your program stop working. Or worse, create hard-to detect incompatibilities and bugs.

Some module authors, perhaps used to less permissive languages, are very sensitive to these risks. So they try to prevent as much monkeypatching as they can.

## Training wheels

I've seen the following pattern in some libraries:

``` lua
-- mymodule.lua
local mymodule = {}

mymodule.foo = function()
  print('this is a public module function')
end

setmetatable(mymodule, {
  __newindex = function(m, t)
    error('The user has unadvertedly tried to add the attribute ' .. t .. ' to the module!')
  end
})

return mymodule
```

After the module has been created and the public functions have been added, the module author has added a metatable that prevents modifying the module. It will
throw an error if the user tries to do something like this:

``` lua
local mymodule = require 'mymodule'

mymodule.bar = function() -- Error 'The user was unadvertedly etc etc'
  print('this is a public module function added by the user')
end
```

So the module autor is providing something similar to a set of *[training wheels](http://en.wikipedia.org/wiki/Training_wheels)*: he's making the module more "secure" for the users by limiting the amount of
monkeypatching they can do.

Don't do that.

Lua is a *dynamic* language. Your users are supposed to be able to tinker if they want to. It's dangerous, yes, but it's also beautiful, and it's one of the things that make Lua special.
[Do what Lua does](2014/03/30/rule-1-do-what-lua-does/).

Also, consider that despite whatever contrivances you add to your module, *the rest of the language remains highly customizable anyway*.

*Training wheels are of little use in a freeway*.


## Beware of locals

Note that if you really want to empower your users to tinker with your modules as they please, there is an extra precaution that you might want to take: Be mindful of local variables used to reference public module functions.

Consider this case:

``` lua
local sumult = {}

local sum = function(a,b) return a+b end
local mult = function(a,b)
  local result = 0
  for i=1,b do result = sum(result, a) end
  return result
end

sumult.sum = sum
sumult.mult = mult

return sumult
```

This is a very simple example of a module implementing addition and multiplication.

Notice how the `mult` function uses a local reference to `sum`, instead of using `sumult.sum`.

While it (very marginally, in most cases) faster, it also presents an issue: If I was the user of this module, I would expect this to return true:

``` lua
local sumult = require 'sumult'

-- override sumult.sum
sumult.sum = function(a,b) return 1 end

print(sumult.mult(5,2) == 5)
```

However, `sumult.mult(5,2)` still returns `10`, even after I have overriden `sumult.sum`.

So I am forced to either modify both functions after including `summult`, or edit the source module (which might be deep inside the luarocks folder).

In my list of priorities, ease of monkeypatching is higher than small speed gains. Unless the use of a local internal reference is justified, I recommend you that you don't *localize* the references to
public methods.

> Locals are faster

<cite><a href="http://lua-users.org/wiki/OptimisingUsingLocalVariables">Traditional Lua incantation</a></cite>

While we are speaking about locals, here's something else I see often that I don't recommend:

``` lua
local myveryfastmodule = {}

local rand = math.rand
local sin = math.sin
local cos = math.cos
local print = print
local pairs = pairs
... -- all the lua functions used in this module, transformed into local variables

... -- rest of the module

return myveryfastmodule
```

Right after declaring the module variable, there is a "block" of local variables that point to *all* the Lua functions used in the module.
Sometimes it takes 20 or 30 lines of code. The rationale behind this is that accessing local variables is slightly faster than accessing globals (like `print`) or global module
functions (like `math.rand`). There's [an article in the LuaUsers Wiki](http://lua-users.org/wiki/OptimisingUsingLocalVariables) that seems to say so.

There is some truth in that: in certain cases creating local references to extensively used functions (in intensive number crunching, big loops, or functions called very often) is justified. But that doesn't justify creating locals for
*all the functions used by your module*.

Your code is 20 or 30 lines of code longer now. Yet, outside of the specific cases I mentioned before, using locals for functions barely makes any difference.

*It's like trying to make a bike slightly faster by painting it with lighter paint.*

Worse still: by making all the functions localized, you are hiding which ones *really* need to be localized. Someone might come after you, read my previous frase, and remove all the localizations. But what if `sin` and `cos`
in particular were *really* used extensively in a numeric loop, somewhere?

My recommendation to avoid this particular can of worms is using the localizations at the beginning of every function, and *only for the functions where performance tests show significant speed increases*:

``` lua
local maintainablemodule = {}

maintainablemodule.calculate = function(x,y)
  -- localize sin and cos here to indicate that they
  -- are extensively used in this particular function
  local sin, cos = math.sin, math.cos

  ... -- lots of loops and crazy stuff with sin and cos
end

return maintainablemodule
```

In some cases it's ok to localize some references at the top of the module - for example, if you are doing a trigonometry module, it will probably make sense to localize the trigonometric functions at the beginning
of the module, but only because most functions in the module will use them.

You shouldn't be localizing `pairs` in that module though.

## Conclusion

Lua manages to strike a balance between flexibility, expressiveness and speed. It isn't particularly concerned with "user protection". Your modules should strive to do the same.

On this article, we've learned how to do so by embracing monkeypatching. We've also talked about locals: how they limit extensibility, and their relationship with speed.

If you have questions or comments, please write them below.
