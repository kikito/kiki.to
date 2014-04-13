---
title: A guide to building Lua modules
---

"Module" is the word used in the Lua language for saying *libraries*.

Several people have [already](http://hisham.hm/2014/01/02/how-to-write-lua-modules-in-a-post-module-world/) voiced their [opinions](http://blog.separateconcerns.com/2014-01-03-lua-module-policy.html)
about the way Lua modules should be written. I will explain my opinion on this series of articles.

<!-- MORE -->

Rules:

* [Rule 1: Do what Lua does](/blog/2014/03/30/rule-1-do-what-lua-does)
* [Rule 2: Always return a local table](/blog/2014/03/31/rule-2-return-a-local-table)
* [Rule 3: Allow monkeypatching](/blog/2014/04/04/rule-3-allow-monkeypatching)
* [Rule 4: Make stateless modules](/blog/2014/04/11/rule-4-make-stateless-modules)
* [Rule 5: Beware of multiple files](/blog/2014/04/12/rule-5-beware-of-multiple-files)
