---
title: 'Rule #4: Make stateless modules'
---

This is the fourth rule of my [Guide to authoring Lua modules](/blog/2014/03/30/a-guide-to-authoring-lua-modules).

<!-- MORE -->

I have been particularly guilty of this breaking this rule in the past.

## State

Something _stateful_ is something which has _state_. Something _stateless_ is something which doesn't have _state_.

_State_ is a general programming term that can be thought of intuitively as _internal memory_. In a stateful module, some functions
can return different results with the same parameters (because some internal memory of the module - its _state_ - has changed).

Here's an example of a stateful module:

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

This module's state is located in a local variable called `values`.
There are other ways to store state - we could have used a global variable. Or a [closure](http://www.lua.org/pil/6.1.html).

Independently of how state is implemented, its effect is the same: some of the functions in the module,
given the same parameters, behaves differently, with identical parameters.

In particular, `get` will return different values with the same input:

``` lua
local dict = require 'dict'

print(dict.get('foo')) -- prints nothing (get('foo') returns nil)

dict.set('foo', 'hello')

print(dict.get('foo')) -- prints 'hello'
```

The module seems to be doing what it was created to do. What is the big deal, then? Why not just let the module be stateful?

And where do you put that state, if not in the module?

Let's start with the _why_.

## The big deal: Multithreading

Lua does not provide any multithreaded facilities by default - it comes with [coroutines](http://www.lua.org/pil/9.1.html), which
enable certain types of "cooperative states", but the flow of execution is unique: at any given moment, only 1 thing is
happening.

But the fact that Lua doesn't include multithreading does not mean it is **impossible** to do multithreading with it. It just means that _if
multithreading is needed, it must be provided by the platform where Lua is embedded_ - just like any other feature not provided by raw Lua.

While it is true that in general platforms tend not to provide multithreaded environments, some of them do. From the top of my head:

* [Openresty](http://openresty.org/) provides a multithreaded model based on [nginx's workers](http://nginx.org/en/docs/beginners_guide.html).
* [Luvit](http://luvit.io/) brings the evented concurrency model from [libUV](https://github.com/joyent/libuv) to Lua.
* [Busted](http://olivinelabs.com/busted/) uses [LuaLanes](hhttp://olivinelabs.com/busted/ttps://github.com/LuaLanes/lanes) (when available) to parallelize tests.

These are the three examples I know, but there's probably more, in other fields besides web development and testing. I suspect the tendency to make
code work in parallell will increase, as [our computers are not getting faster, but more parallelized](http://www.theconnectivist.com/2013/10/moores-law-is-dead-the-future-of-computing/).

You may have noticed that every project above uses a different multithreading library.
Each one comes with its own ways to share state amongst threads. Sometimes they rely on passing messages around. Others there's a
dedicated "shared memory space" where all threads can write/read - hopefully in a concurrency-aware way.

There's one constant: **None of those libraries can handle stateful modules well**.

For example, if you try to use the `dict` module above in openresty, depending on how you configure it, it might seem to work for some time (seconds, days). Then, suddenly, it will seem as if the
dictionary was "losing" some values (a second worker would start, with his own copy of `dict`, not sharing values with the first). At some points all values would seem to evaporate
(when a worker died and was respawned by nginx).

In conclusion, **if you want to write a platform-independent module, you must make it stateless**. Otherwise it almost certainly will fail on multithreaded enviroments. And those are
a reality. When you write stateful modules, you are, in fact **writing platform-specific code**.

Note that for the particular case of openresty, it doesn't make sense to create a `dict` module, since Openresty provides one by default: [`ngx.shared.DICT`](http://wiki.nginx.org/HttpLuaModule#ngx.shared.DICT).
But for the general case, we need some place to put that state that we previously put inside our modules.

So where do we put the state?

## Module Instances

The way we solve this connumdrum is by providing _constructors_: this is, functions that create and return _instances_. I'm using the term loosely here - an instance can be anything
that stores state. It can be a table (the usual case) or function closure (a bit more exotic, but possible). I don't mean instance like in Object Orientation.

Instances leave in the _aplication_'s memory (as opposed to the module's). The state is also _visible_ instead of _implicit_,
and can be handled with whatever synchronizing/sharing mechanisms the application has.

The convention seems to be naming the _constructor_ `new`, or a derivate (like `newDictionary` or `newUser`).

It is usually desirable to add `methods` to the instances - but I am using the term loosely again. Here by _methods_ I just mean "functions whose first parameter is `self`".

It is also usual not to want re-create all the methods for every instance returned. Instead, these methods are made available to the instances though a metatable's `__index` metamethod.

Finally, it is usually a good idea to make the state available for the application (if the state should be treated as a "private" variable, it can be prefixed with an underscore).

Here's how you would make the `dict` module stateless:

``` lua
local dict = {}

-- private methods
local DictMethods = {}

function DictMethods:get(key)
  return self._values[key]
end

function DictMethods:set(key, value)
  self._values[key] = value
end

local DictMt = {__index = DictMethods}

-- public methods
dict.new = function()
  return setmetatable({_values = {}}, DictMt)
end

return dict
```

And here's how you would use it:

``` lua
local dict = require 'dict'

local d = dict.new()

print(d:get('foo')) -- prints nothing
d:set('foo', 'hi again')
print(d:get('foo')) -- "hi again"
```

On this example, the state is on _my application_, not on the module (on the `d` variable).
I am free to use any of Openresty's mechanisms to "share" this dictonary amongst all the workers, if I so see fit. I can serialize `d._values` and move it to a database, for example.

## Pros and cons

Programming is a game of tradeoffs. This rule is no exception. Making modules stateless solves many problems:

* The modules are more portable. They will work (or can be made to work) in any environment and threading model.
* It reduces invisible errors - the initial `dict` can "seem to work fine" for *days* before it fails on Openresty.

But it also has a couple disadvantages:

* The module code is more complex. The initial `dict` is simpler to understand than the second.
* The interface some is also more complex. We gained an extra method (`new`) and an extra variable (`d`) to manage. Some methods now require using `:` instead of `.`, which might disorient new users.

I think the benefits outweight the inconveniences on this particular case. The increase in complexity is not enormous, while portability is one of the main goals in Lua.

## Conclusion

I started defining what is state, and what means to be _stateful_ and _stateless_.

I then explained how multithreaded code, even if it isn't provided by default with Lua, does in fact exist, and it doesn't merge well with stateful modules.

Finally, I provided a way to fix this by moving the state from the module to the application using _constructors_.

If you have questions or comments, please write them below.

