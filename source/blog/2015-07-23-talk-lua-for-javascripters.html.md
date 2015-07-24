---
title: "Talk: Lua for Javascripters"
date: "2015-07-23 16:37 UTC"
---

I was invited to give a short talk (30 minutes) in [CartoDB](https://cartodb.com/)'s offices last friday.

This was not part of a conference or anything; they just like to bring someone to their offices some Fridays, and have a short talk before lunch.

I've got this self-imposed duty of preaching the Lua Word to the masses. Knowing that a lot of people in CartoDB use javascript,
I thought it was a good opportunity to compare both languages.

Here are the slides I used. As usual, my slides don't really stand well by themselves. I will try to explain the main points below.

<iframe src="https://kikito.github.io/lua-for-javascripters/"></iframe>

[Direct Link](https://kikito.github.io/lua-for-javascripters/)

I divided the talk into 3 sections.

The first one "Intro", delves into the history of both languages, and their uses. It also introduces "The *Browser Curse*": The expectation that, if I build a website today,
future browsers should be able to handle it correctly. The main thesis of the talk was this expectation fundamentally conditions how javascript evolves. I also pointed
out that Lua has no such restriction (new versions of the language are not fully backwards-compatible).

> The Browser Curse: If I build a website today, future browsers should be able to handle it

The middle section is all about syntax comparison between the two languages. My main objective here was making clear that Lua has almost feature-parity with ECS6 (well, maybe
90%). I don't know whether I succeeded in transmitting this. I felt I was missing more meat in this section, but I had to cut somewhere.

A secondary point I wanted to stress on this section is that Lua is a very economical language: it reuses its
parts again and again. I mentioned this when looking at its multi-line comment (which reuses the multi-line string syntax),
and of course, when explaining tables.

The final section of the talk, "Conclusion", was basically about "what is left to compare". I started talking about javascript's infamous *Bad Parts*, of which the `==` operator
is one (Automatic Type Conversion is the real culprint though). I explained that, due to the aforementioned *Browser Curse*, javascript **needs** to keep its bad parts intact.
It can "add new stuff" (like the `===` operator), but it can't "fix" bad parts (because that would potentially break the websites made 5 or 10 years ago).

Similarly, javascript can't even *deprecate* outdated features. `let` is objectively better than `var` in all ways, but again, removing `var` would break old websites. So javascript
needs to "drag it along".

> In javascript you can't deprecate bad or outdated parts

This taxes javascript significantly. I compared the two most popular implementations of both languages (V8 and LuaJIT), and the javascript one was **10 times bigger** than the Lua one.
Not only that: it is also slower in most tests cases. Even if V8 is maintained by a team of engineers managed by Google and LuaJIT is basically maintained by a single (very gifted) individual.

The differences in size, speed, maintainability and ... "cruft" can all be attributed to the *Browser Curse*, in my opinion. I draw a strong parallelism with C++.

I left the most fun for the end: compiling Lua 5.2 in Turbo C++ 1.0, a C compiler which pre-dates the first version of Lua by several years.

Overall, I think people enjoyed the talk. I hope I was able to make at least some of them curious about Lua.

Personally, I appreciated the opportunity of trying a new talk in front of a small audience. I recommend it to everyone.

I also arrived to a somewhat important conclusion while writing the talk: previously I have stated my desire
of being able to use Lua in a browser. I have reviewed that opinion completely. I don't want Lua to ever
*touch* a browser. I don't want it to get infected with the *Browser Curse*.



