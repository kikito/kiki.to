---
title: Operations
---

Traditionally, the technical tasks involved in creating a web application are divided into two main groups: *development* and *operations*.

<!-- MORE -->

*Development* involves *programming*. Some people treat both words as equal. But they are wrong. Development also involves estimation, planning,
requirement gathering, finding appropiate names for things, balancing tradeoffs, empathy, and so on.

Until not so long ago, I considered that *operations* just meant "taking care of the servers". That was simplistic; like development,
operations is a complex multi-faceted world. There is estimation, requirements, planning, provisioning, automation, tracking, graphing,
costs, security, and probably other things that I still don't know about.

Recently, the two are merging together, to become *devops*. But I think enough has been written about that; I want to talk about pure
operations here.

## The early days

My first forays into *ops* were quite painful. The most trivial server change would take me days. Fortunately most of the time I could
find someone to do the changes instead of me. But sometimes I could not escape; I had to roll up my sleeves and make things work.

I have commited an infinity of stupid mistakes: when something didn't work, I didn't go to the logs. Things like that.

I have also commited my share of Big Operation Sins: I made changes in production servers, with no backup and no certainty that the changes
would not destroy client data. I didn't "sin" often; the infrequency of my crimes, however, was not a result of my
professionalism, or even a sense of efficiency. It's just that, if anything went wrong, I would have to spend more time fixing it,
that is, doing operations.

So yes, for a period of 2 or 3 years, operations were just that: non-enjoyable, but necessary tasks that I had to endure from time to time.
The cost of doing business.

With time, my passionate hate receded to common hate, and then to annoyance. And then it plateaued.

I am happy to write that I am finally past that phase now.

## The kick

When I started working on [3Scale](http://www.3scale.net/), one of the first things I noticed was that most of the developers were more aware
of the operations side of things than what I was accustomed to.

During my last stay there (I work remotely, the office is in Barcelona and I'm in Madrid) I decided to give a better look at two of the key pieces
of our setup, operations-wise: [Docker](https://www.docker.io/) and [Openresty](http://openresty.org).

I have spent the last two weekents tinkerig with [dockerfiles](https://github.com/kikito/dockerfiles), configuring a dockerized openresty web
server that, if I did everything ok, has just served you this article. I have rebuilt the container many times; I still made lots of mistakes,
but at least I could recover faster than years ago. And at some point I realized that I must have enjoyed the process - I did stay awake until
3 in the morning tinkering.

I even could draw some parallelisms with programming. The feeling I get when a server "just doesn't work", is not dissimilar to the one
I get when a pesky programming bug keeps skipping detection. Both issues, when resolved, trigger the same kind of elation. I have also gone to bed
thinking about an issue in operations, and the solution came to me 3 days later while in the shower.

It would seem that both fields require some degree of obsessive-compulsiveness. I don't think we're *[vampires and werewolves](http://blog.codinghorror.com/vampires-programmers-versus-werewolves-sysadmins/)*.

It also worked the opposite way: working in ops has made me more conscious about things that I don't enjoy about programming (like debugging multi-threaded code).

## Conclusions

* Don't get me wrong: I still hate ops. I just don't hate it *all the time*.
* I'm pretty sure that will never be an operations person. But I can handle myself in certain situations.
* I have respect Ops (the tasks and the guys) more than I do when I started. So that's good.
* Sometimes, you will be happier not knowing what you are really thinking.










