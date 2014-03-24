---
title: Rebooting the blog with middleman
---

Some time ago, I [created this space](/blog/2012/03/06/starting-the-blog-with-octopress/) using [octopress](http://octopress.org/).

The experience was not pleasant:

<!-- MORE -->

* Octopress has a very "kitchen-sink" mindset. In a way, it provides too many tools by default.
* The work folder is too cluttered with auxiliary files and folders.
* Publishing a new post was an ordeal - partly because octopress' layout was so alien.
* Much of the pain points I got from using Octopress could actually be attributed to [Jekyll](http://jekyllrb.com/).

Even if I didn't publish much on this blog, I've used Jekyll quite often in the past - I used it almost for any static site that I needed to do. I've answered a significant amount of Jekyll-related questions in [stackoverflow](http://stackoverflow.com).

In the past this made sense: Jekyll was the best static site generator that I knew. But that is not the case any more.

Middleman is a modern static site generator that solves much of the pain points that came with Jekyll.

* It does not use [liquid markup](http://liquidmarkup.org/), which is a very limited and clunky templating language. Instead, templates can be created using [Eruby](http://en.wikipedia.org/wiki/ERuby)
  or [HAML](http://haml.info/)
* It supports [SASS and SCSS](http://sass-lang.com/) out-of-the-box.
* It is not limited to blogs; it can be used to generate any kind of static website.
* It has lots of plugins available; middleman plugins are regular ruby gems, which simplifies things enormously.
* Configuration stays in a single place, `config.rb` (you could have a `Rakefile` too, but it's optional) instead of the 4 required by Octopress.

As a result, the folder layout of [my middleman-based repo](https://github.com/kikito/kiki.to) is much cleaner than [the old octopress-based one](https://github.com/kikito/old-blog/tree/source).
Creating posts is easier (they have less metadata). Publishing is easier too (very simple commands)

Since I know myself, I'll probably end up adding a `Rakefile` to automate things a bit more, so that instead of using 2 commands to publish stuff I can do it with just one.

But for me, Jekyll is dead. Long life middleman.
