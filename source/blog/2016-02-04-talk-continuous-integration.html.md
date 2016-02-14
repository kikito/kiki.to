---
title: "Talk: Continuous Integration"
date: 2016-02-04
---

I recently gave a talk in [FOSDEM](https://fosdem.org), which is a great event if, like me, you are into
open source.

<iframe src="https://kikito.github.io/ci-with-lua/"></iframe>

[Direct link to slides](https://kikito.github.io/ci-with-lua/)

You can watch the whole talk [in video format](http://video.fosdem.org/2016/k3201/continuous-integration-with-lua.mp4).
If you prefer a text-based approach, read on.

I'll start by explaining what I mean by Continuous Integration, and why it is
important. Then I will explain how I implement it in another article.

My definition of Continuous Integration is:

> Automatic, Frequent Checks on code.

*Automatic* means that the checks are performed by computers "of their own accord": a human does not say
"execute these checks now". *Frequent* means that the checks happen often: at least several times per day. Usually
every time there is a push to any branch in a repo. The *Checks* can be anything, but the ones people tend
to think about when they think about Continuous Integration are *specs*. For now, let's say that specs are
"extra code which makes sure that your **real code** does what is supposed to" (we'll talk more about them later).

All this is starting to sound like a lot of work. Writing extra code? Configuring machines to run checks? That sounds
like a lot of time, effort, and money. It begets the question: why do all this in the first place?

To answer this, I have a story. It could be seen on this graph:

![Effort Graph](http://kikito.github.io/ci-with-lua/img/effort-graph.png)

This graph represents two parallel universes. Both of them start in the same point in time: a team of people
who don't know about continuous integration start working on a software project.

On the red universe, the team considers continuous integration (and testing in general). Things start well. Features
are added quickly and with little effort. They have a "preview" server where a QA team reviews changes before they
are deployed to production.

Over time, changes happen: the scope of the project is expanded. New people join the team. Other people leave the team.
Features are added quickly to meet deadlines. And relatively soon, making changes to the project, either to add new features
or to solve errors, start taking longer and longer.

On the green universe, the team decides to start practicing CI. This means extra work at the beginning.
And not just a little! Learning to write specs effectively is a skill which requires practice
(fortunately once you learn it once you can apply it to other projects, spreading the cost a bit). There are also
machines to configure, and extra code to write. So yes, there is a "peak" of effort at the beginning.

Once changes start arriving, however, CI starts helping out. Adding new features is easier when the machines tells you
quickly whether you are breaking existing functionality (instead of having to wait for the QA guys to manually find each
problem). A similar thing will happen when a new person joins the project and starts making changes: the CI server will
warn them about these errors. And when a veteran leaves the project, his knowledge about "this weird edge case which needs
to be tested every time you change this variable" will not leave with him: it will remain in the project, in the form of
an automated spec.

In the long run, in the green universe the cost of every change still go up; but CI makes this rate grow slower. Investing
effort in CI is investing effort in *supporting future changes*. And all software projects, especially the successful ones,
suffer a lot of changes in their lives.

I have this mental image about it: writing software is similar to digging a mine.

![Mine](http://kikito.github.io/ci-with-lua/img/mine.jpg)

Mine tunnels usually have these supports on their sides and ceilings, which prevent them from collapsing in case of an earthquake.
Continuous Integration is like the supports on the sides of the tunnel. It is an *initial investment you do to preserve
your future*; a foundation.

Change is an earthquake. I have called it "the silent killer of software". Successful software projects usually don't
get successful because of what happens at the beginning phase; they usually get popular after having been around for
some time. It's at that time where their ability to cope with change becomes critical. Every effort done during the
starting phase pays off on this stage.

With this I finish my explanation of what Continuous Integration means, and why it is important.

If you want to read how I implement it in Lua, please read [this text's companion article](/blog/2016/02/04/talk-continuous-integration-with-lua/),
where I delve on the specifics of setting up CI with Lua.
