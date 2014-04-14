---
title: "Rule #6: Break the rules"
---

This is the sixth rule of my [Guide to building Lua modules](/blog/2014/03/30/a-guide-to-building-lua-modules).

<!-- MORE -->

None of the previous 5 rules is absolute. Occasionally, the best course of action is to ignore them.

This rule acknowledges that. But this doesn't mean you have _carte blanche_ to break any rule at any moment. The complete text of this rule is this:

> Break the rules when you have a good reason.

The rule says that you must _justify_ every breakage with a _good reason_. But which reasons are _good_?

## Good reasons

Good reasons are based on objective, testable or measurable evidence - and on occasion they are accompanied by palliative actions.

* _"I ignored [rule #1](/blog/2014/03/30/rule-1-do-what-lua-does/#short-names-for-everything) and used under-scored names since that's the convention in my team"_
* _"I'm not returning a table on this module ([rule #2](/blog/2014/03/31/rule-2-return-a-local-table/)) because it's part of an internal package; I don't need meta fields here, just a single function"_
* _"The performance tests for the typical case of this function run 40% faster if I localize this reference, so I'll [disallow monkeypatching](/blog/2014/04/04/rule-3-allow-monkeypatching/#beware-of-locals) here and use locals"_
* _"We are storing state on this module as a quick-and-dirty hack to get things ready for next week's presentation. We've scheduled a refactoring to [move the state to the application](http://localhost:4567/blog/2014/04/11/rule-4-make-stateless-modules/#module-instances) later"_

## Bad reasons

Bad reasons, on the other hand, are subjective, based in the _unknowns_, or just plain lazy. They take no remedial actions:

* _"I just don't like [monkeypatching](2014/04/04/rule-3-allow-monkeypatching)"_ – subjective, goes against other rules ([do what Lua does](/blog/2014/03/30/rule-1-do-what-lua-does/)).
* _"I don't know how to implement this module without state ([rule #4](rule-4-make-stateless-modules))"_ (based in unknowns, lazy)
* _"I don't have time to apply this"_ (no remedial action)

## Conclusion

Rule #6 turned out to be the smallest of the rules. It's also very powerful. Remember [what uncle Ben said](/2014/04/04/rule-3-allow-monkeypatching/#spidermonkey) about power.

If you need to break one of the rules and want to talk about your reasons, feel free to contact me; either post a comment on the rule in question or [tweet at me](https://twitter.com/otikik).

Thanks for reading!




