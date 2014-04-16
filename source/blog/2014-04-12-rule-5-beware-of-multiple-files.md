---
title: "Rule #5: Beware of multiple files"
---

This is the fifth rule of my [Guide to building Lua modules](/blog/2014/03/30/a-guide-to-building-lua-modules).

<!-- MORE -->

## Packages

Even when creating a module that does [one thing, and one thing only](/blog/2014/03/30/rule-1-do-what-lua-does/#one-thing,-and-one-thing-only),
it is sometimes desirable to "split" its sourcecode into several files.

In Lua, when a library is divided into several files, each of the files is called a _module_, while the library itself is called a _package_.

Writing packages in a portable way is more difficult than it seems. This is partly due to some design decisions in Lua.

## An unassuming language

Lua can run in a lot of environments: from a huge multi-core server with several terabytes of RAM, to a tiny embedded microprocessor
with 200 KB of memory - and a custom C compiler. In order to remain portable, Lua is written
in a platform-independent subset of C ([C89](http://en.wikipedia.org/wiki/ANSI_C) to be exact).

So Lua assumes very little about the platform in which it runs. The concept of _filesystem_ is reduced to a minimal expression . To lua, every file loaded via
[`loadfile`](http://www.lua.org/pil/8.html) or [`require`](http://www.lua.org/pil/8.1.html) is identified by a _path_ - a string. This string is passed to the
operative system, which will load the file into a string and return it to Lua. And that's it. To Lua, the filesystem "a black box that transforms paths into source".

There isn't even a concept of _directory_ or _folder_ in Lua - C can't handle folders in a platform-independent way, so neither can Lua. You can not do
seemingly trivial things like listing the contents of a folder; One has to rely on external libraries like [luafilesystem](http://keplerproject.github.io/luafilesystem/) to do so.

As a result, in Lua you can't say "this package is all the modules of this folder". You can't use an "asterisk" to "require all the files in a folder". In order to load a
package, you have to list the modules that integrate it, one by one. It is expected that the package itself comes with a special module dedicated
to this task.

We will talk about this special module in a moment. But first, let's examine the `package` lib.

## `package`

Lua uses a global variable called `package` to store information about modules and packages.

* `package.loaded` is a table. It acts as a _module cache_. The first time a module is required (e.g. with `require 'foo'`) its value is stored inside `package.loaded.foo`. Next time it's
  required, instead of reading `foo.lua` again, `package.loaded.foo` will be returned.
* `package.path` is a string of paths, separated by semicolons. When a module is required (e.g. with `require 'foo'`), `package.path` is used to "try" several places
  in the local filesystem where the modules can be.

`package` has [more properties](http://www.lua.org/manual/5.2/manual.html#pdf-package.config), but we'll concentrate on `package.path` here.

This is how `package.path` looks by default in OS X:

``` txt
./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua; \
/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua
```

While not very easy to parse for humans, this string is used to "look for modules" in several places. The best way to see it in action is by
requiring a non-existing module:

``` lua
require 'non-existing'
```

That will throw this error in OS X:

``` lua
module 'non-existing' not found:
    no field package.preload['non-existing']
    no file './non-existing.lua'
    no file '/usr/local/share/lua/5.1/non-existing.lua'
    no file '/usr/local/share/lua/5.1/non-existing/init.lua'
    no file '/usr/local/lib/lua/5.1/non-existing.lua'
    no file '/usr/local/lib/lua/5.1/non-existing/init.lua'
    no file './non-existing.so'
    no file '/usr/local/lib/lua/5.1/non-existing.so'
    no file '/usr/local/lib/lua/5.1/loadall.so'
```

Two things are worth noting:

* The question marks (`?`) in `package.path` are replaced by `non-existing` and tried in sequence.
* Sometimes `non-existing` is also followed by `/init.lua`.

That second point is the Lua language telling us how to create packages - it looks for a module called `init.lua`.

## `init.lua`

It turns out that the language defaults suggest that in order to create a package, one has to put all its modules in a folder named like the package,
and then list and `require` these submodules from another module called `init.lua`.

So your package might end up looking like this:

``` txt
my-package
  +-- init.lua
  +-- module1.lua
  `-- module2.lua
```

Now we just need a way to load `module1.lua` and `module2.lua` in `init.lua`. It turns out that this is also tricky.

## The `current_folder` trick

The obvious way to reference `module1` and `module2` from `init.lua` is by using the package name, `my-package`:

``` lua
-- my-module/init.lua
local module1 = require 'my-package.module1'
local module2 = require 'my-package.module2'

local my_package = {}

... -- fill up/initialize my_package with module1 and module2

return my_package
```

This strategy could be used to cross-reference modules from within the package itself; for example `module1` could be required from `module2`:

``` lua
-- my-module/module2.lua
local module1 = require 'my-package.module1'

local module2 = {}

...

return module2
```

Unfortunately this has two problems:

* If we ever want to change the name of the module, we'll have to "hunt down" all the references to the old name in the requires.
* If the module ever changes its location (for example if it's being loaded locally, and it's moved from `./my-package` to `./lib/my-package`)
  all references will have to be manually changed.

It would be much easier if we could reference the "current folder" when doing require; but as we mentioned at the beginning of the article,
Lua does not provide any folder-related facilities. We can, however, use something: the expression `(...)`, when evaluated at the top of a
module, returns the "path" used to require it (this is mentioned in [`require's doc`](http://www.lua.org/manual/5.2/manual.html#pdf-require)).

```lua
print(...)
```

The instruction above, when executed in the "top scope" of a module (i.e. outside of all the fuctions of the module) will print the _path_ used by
`require` to load the module. In other words, if the instruction above was in a module loaded via `require 'foo.bar.baz'`, we would get `foo.bar.baz`
in the standard output.

Using that knowledge and some Lua pattern matching, we can build our own "current folder" and then use it to require modules using a relative path.

`init.lua` can be required with the file name (`require 'my-module.init'`) or without (`require 'my-module'`), so we must remove the `.init` part from `(...)`, but only when it's present.

```lua
-- my-module/init.lua

local current_folder = (...):gsub('%.init$', '') -- "my-module"

local module1 = require(current_folder .. '.module1')
local module2 = require(current_folder .. '.module2')

... -- same as before
```
`(...)` ends with the "module name" in all the other modules of the package (`module1` & `module2` in this case), so we use a pattern always remove the last dot and everything behind it:

```lua
-- my-module/module2.lua

local current_folder = (...):gsub('%.[^%.]+$', '')
local module1 = require(current_folder .. '.module2')

... -- same as before
```

This "`current_folder` trick" will work with the default `package.path`, and with other "sane" values for it.

## One last hurdle: local packages

Ok so now we have a folder with a `init.lua` file that uses the `current_folder` trick to references other modules in the package.

So let's use it!

``` txt
$ tree
.
+-- my-package
    +-- init.lua
    +-- module1.lua
    `-- module2.lua

1 directory, 3 files

$ lua
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
> require 'my-package'
stdin:1: module 'my-package' not found:
    no field package.preload['my-package']
    no file './my-package.lua'
    no file '/usr/local/share/lua/5.1/my-package.lua'
    no file '/usr/local/share/lua/5.1/my-package/init.lua'
    no file '/usr/local/lib/lua/5.1/my-package.lua'
    no file '/usr/local/lib/lua/5.1/my-package/init.lua'
    no file './my-package.so'
    no file '/usr/local/lib/lua/5.1/my-package.so'
    no file '/usr/local/lib/lua/5.1/loadall.so'
```

Lua can't find the package - It turns out that by default, `package.path` does *not* try to load `?/init.lua` - in other words, _local packages can not be
loaded directly from the current folder - only if they are installed on the system, for example installed via luarocks_.

There are four ways to solve this.

One way which I **don't** recommend is simply doing `require 'my-package.init'` instead of `require 'my-package'`. While this will work,
the package will be loaded differently when using a local version or a luarocks version. It's easy to have both of them simultaneously loaded in the
same program by mistake.

The second alternative is modifying `package.path` to include `?/init.lua` before requiring any local package. This will also work, but I'm not a big fan of
modifying a global variable just so that a package can be loaded.

The third alternative is merging all files into a single one called `my-package.lua`, [like javascript libraries often do](https://github.com/gruntjs/grunt-contrib-concat).
But I would rather use a feature from inside the language, instead of sidestepping the problem using external tools to concatenate the files.

The final alternative is adding an extra file, called `my-package.lua`, which `require`s and returns `my-package.init`. We can use `(...)` here too, so we can
change the file name and the folder name to something else later on, and they will still work:

``` lua
-- my-package.lua
return require((...) .. '.init')
```

So the folder structure will end up like this:

``` txt
.
+-- my-package
|   +-- init.lua
|   +-- module1.lua
|   `-- module2.lua
`-- my-package.lua
```

This will make `require 'my-package'` work, even without modifying `package.path` - the `my-package.lua` file will be loaded, and from there we can load `init.lua`.

I should mention that there's a bit of controversy regarding this point in the Lua comunity.

Some people argue that in that case it doesn't make sense to use a `init.lua` file in the first place. After all,
we could require `module1` and `module2` from `my-package.lua` and avoid using `init.lua` at all, and that all references to
`init.lua` should be removed from `package.path`. Others argue that this would break backwards-compatibility with a lot of libraries,
and that having all the modules inside a folder is tidier. So what we need is just adding `?/init.lua` to `package.path`.

Here's a mailing list thread, displaying both sides of the discussion:

http://lua-users.org/lists/lua-l/2009-05/msg00499.html

I personally think that `package.path` should include `?/init.lua`. As it stantds, it's an inconsistent default, which
works in some cases and not in others.

But until that is fixed, I favor using both files - `init.lua` and `my-package.lua`. I don't think it's ideal, but I think it's the best compromise
we can get for now. It's backwards compatible, and also future-compatible, if they decide to include `'?/init.lua` in `package.path`.

# Conclusion

We started defining what a _package_ is. We continued by examining the limited tools that lua has for handling file loading from different paths.

Then we examined `package` & `init.lua`. We came up with the `current_folder` trick to require modules using relative paths. And finally we examined issues
with loading local packages, and listed the possible solutions.

If you have any questions or comments about any of the above, please use the form below.
