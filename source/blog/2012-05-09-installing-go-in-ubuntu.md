---
title: "Installing Go in Ubuntu using the PPA"
---

I've recently started getting interested in [Go](http://golang.org) (also known as *golang*), one of the new programming languages being developed by Google (another one is [DART](http://www.dartlang.org/) , but I'm not interested in that one. Yet).

-MORE-

One of the first hurdles I have encontered is that the [installation instructions](http://golang.org/doc/install#freebsd_linux) seem incomplete, at least for Ubuntu.
They tell you to go and download the source code and compile it on your machine. While I'm not afraid of compiling stuff myself, I'm not so fond of maintaining the compiled programs up-to-date manually. It reminds me of windows, brr.

When I'm trying new software I always try to find:

a) The official apt-package with `apt-cache search`, which will manage the updates for me, or
b) A [ppa](http://www.makeuseof.com/tag/ubuntu-ppa-technology-explained/) , which is basically the same thing, except that
   instead of an "official" unkown Ubuntu guy these updates are managed by an unkown guy.

I tried to find a ppa for golang and, lo and behold! [There is one](https://launchpad.net/~gophers/+archive/go), and it seems reasonably official!

Since the official instructions don't mention how to use this wonderful resource, allow me:

``` bash
sudo add-apt-repository ppa:gophers/go
sudo apt-get update
sudo apt-get install golang-stable
```

Easy peasy! No compilations or anything needed. And when Go gets a new version, you will receive it as a software update. Cool!

One minor thing though - Go expects you to have defined a `GOPATH` environment variable. This variable should point to a place where the Go libraries ("packages", in
Go lingo) are installed. For newbies (like me) it's better if it's a folder inside your home directory.

So it's just a matter of creating it! (I name it `.go` so it is invisible by default, but you may want to make it more public). Notice that there is no `sudo` on this line.

``` bash
mkdir $HOME/.go
```

Finally, create the environment variable. Add this to your .bashrc, .zshrc or equivalent file, depending on whether you use bash, zsh or other shells.

``` bash
export GOPATH=$HOME/.go
```

The next console you open will be prepared to execute go!

That's all for now. Go get some go!
