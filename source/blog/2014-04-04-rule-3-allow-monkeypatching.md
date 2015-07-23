---
title: 'Rule #3: Allow extensions'
---

This is the third rule of my [Guide to authoring Lua modules](/blog/2014/03/30/a-guide-to-authoring-lua-modules).

<!-- MORE -->

## Extensions and Monkeypatching

Lua is a *highly extensible language*. It allows you to add new functions to existing modules. For example:

``` lua
math.clamp = function(x, min, max)
  return math.min(math.max(min, x), max)
end

print(math.clamp(10, 0, 5)) -- 5
```

[Monkeypatching](http://en.wikipedia.org/wiki/Monkey_patch) is the act of "modifying core parts of a language or system" (read the previous wikipedia article before to learn more).

Lua is a *also highly monkeypatchable*. Consider the following example:

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

With monkeypatching you can do lots of interesting and subtle things. But you can also make your program stop working.
Or worse, create hard-to detect incompatibilities and bugs.

Some module authors, perhaps used to less permissive languages, are very sensitive to these risks.
So they make great efforts to prevent monkeypatching in their libraries.

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

Lua is a *dynamic* language. Your users are supposed to be able to tinker if they want to. It's dangerous, yes, but it is one of the things that make Lua special. Remember:
*[Do what Lua does](2014/03/30/rule-1-do-what-lua-does/)*.

Consider that despite whatever contrivances you add to your module, *the rest of the language remains highly customizable anyway*.

*Training wheels are of little use in a freeway*.

Notice that these training wheels, critically, also prevent extending the


## Localizing All Functions is not a Good Practice

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

My recommendation is: do that *only inside the functions where performance tests show significant speed increases*. In other words, do this:

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

In some cases it's ok to localize some references at the top of the module - for example, if you are doing a trigonometry module,
it might make sense to localize the trigonometric functions at the start, but only because most functions in the module will use them.

In any case, when you are doing performance-related changes, your guiding principle should be performance tests, not human intuition. We are
incredibly bad at it (you and me). If you are really concerned about performance, write those tests. Then you will know.

## Conclusion

Lua manages to strike a balance between flexibility, expressiveness and speed. It is not particularly concerned about protecting the end user from
mistakes or misunderstandings.

On this article, we've talked about locals: how they limit extensibility, and their relationship with speed.

If you have questions or comments, please write them below.
