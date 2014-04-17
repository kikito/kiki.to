---
title: "Rule #1: Do what Lua does"
---

This is the first rule of my [Guide to authoring Lua modules](/blog/2014/03/30/a-guide-to-authoring-lua-modules).

<!-- MORE -->

Lua comes with a small number of modules built-in: `table`, `string`, `math`, etc. When in doubt, ask yourself this question:

> How do the standard Lua modules do it?

I have been able to extract some rule from the standard Lua modules, and have identified some commonly-used modules which do things differently. What follows is a list.

## One thing, and one thing only

All the top-level modules are very concise and specific; it is desirable that your modules are similar.

This doesn't mean that they should provide a single function, but the functions they provide should all
be grouped under the same umbrella.

[Penlight](http://stevedonovan.github.io/Penlight) is a clear example of a library that doesn't follow this rule. It is big, and does many different things.


## No `self` on the top-level functions

None of the functions in the standard Lua library takes `self` as a parameter.

This means that the module functions in Lua are used with a dot (`.`) and not with a colon (`:`):

``` lua
local a = math.floor(5.3)                            -- not math:floor(...)
local phrase = table.concat({'hello', 'world'}, ' ') -- not table:concat(...)
```

There's one apparent exception to this rule when dealing with strings. They appear to use (`:`):

``` lua
local msg = ("Hello, %s"):format('Peter')
```

But this is ok because the first parameter passed to `format` in that case is not the `string` module, but a string instance. The following equivalent call should make it evident:

``` lua
local msg = string.format("Hello, %s", 'Peter')
```

In any case, in order to do what Lua does, a module should always use `.` on its top-level functions.

[Olivine Labs' say](https://github.com/Olivine-Labs/say) module breaks this expectation, requiring `self` to be passed as a first parameter to its own methods. This goes against Lua's way of building modules.

## Functions at the end

When any standard lua function accepts several parameters, and one of them is a function, that parameter is always the last one (before optional parameters).

Consider, for example, `string.gsub`:

``` lua
string.gsub("banana", "a", string.upper) -- bAnAnA
```

Putting the functions at the end makes calls easier to read when the parameter is a multi-lined anonymous function:

``` lua
string.gsub("a world goes bananas", "(%a)(%w*)", function(first, rest)
    return first:upper()..rest:lower()
end) -- A World Goes Bananas
```

Here's how the call would look if the function was the first:

``` lua
string.gsub(function(first, rest)
    return first:upper()..rest:lower()
end, "a world goes bananas", "(%a)(%w*)") -- A World Goes Bananas
```

The multi-line function moves the rest of the parameters several lines down, obscuring the lecture of the call.

[Penlight's pl.func](http://stevedonovan.github.io/Penlight/api/modules/pl.func.html) module follows Perl's convention of putting the function first instead of following Lua's. I consider that a mistake.

## Short names for everything

Names (of modules and methods) tend to be short - almost always a single word. Names with more than 1 word are neither `under_scored` nor `CamelCased` (for example, `getmetatable`).

I must confess that I'm not a fan of that last part. It is clear that no one is going to use nameswithseveralwordsandnoseparations. It's unreadable. By not providing a suitable convention, Lua is encouraging everyone to pick theirs - so there're Lua
modules using `under_scores` for everything, other use `CamelCase`, and others have to mix-and-match because they use both kind of modules.

Note that [PiL](http://www.lua.org/pil/16.2.html) uses `CamelCase` but not `under_scores`. As a result, when I need to use several words, I tend to use CamelCase (unless I work in a project where `under_score` is the norm, then I adapt to that).

I also found out that while most top-level functions are verbs, some of them are not, especially on the `string` library: `string.bytes`, `string.char`, `string.upper`, `string.len`. In this case brevity has prevailed over uniformity. Those function names
are the exception, in general Lua tends to use (short) verbs for its functions. I think it's safe to say that functions should be named after verb names whenever possible, if we would want to follow Lua's footsteps.

A good reference on naming is the [Lua style guide](http://lua-users.org/wiki/LuaStyleGuide).

## Conclusion

These are just some of the traits I was able to extract by studying the standard Lua modules. I try to follow these guidelines in all the modules I build, and it just "feels right". I recommend following these guidelines (well, except for the last one) when building any module.

If you have doubts about one characteristic that doesn't appear on this guide, ask yourself the question at the beginning of this article.

And if that doesn't help, comment below.


