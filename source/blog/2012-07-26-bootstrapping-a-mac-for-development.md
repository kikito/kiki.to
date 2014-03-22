---
title: "Bootstrapping a mac for development"
---

I recently acquired a new development machine - A Mac Book Air. I had
been resisting it for quite some time now.

<!-- MORE -->

It is a very fine machine, but I’m not familiar with its operative
system (I used to use Ubuntu on a custom-made PC).

I’ve spent a couple days installing and configuring it for development
usage (mostly Ruby on Rails). Here’s what I’ve done so far:

## Locate the terminal

I was able to find the terminal using the "find tool" (a little
magnifier glass near the top right of the screen) and typing "terminal".
Once I clicked on it, it appeared on the Dock. I "left-clicked" (clicked
with two fingers) on it to display a contextual menu. I choose
`Options > Keep in Dock` so I didn’t have to look for it again.

## Upgrade the Operative System

A new version of OSX (codename "Mountain Lion") had been released the
day before my laptop arrived. Knowing that updates do sometimes provoke
conflict with installed software, the first thing I did after booting up
the machine was upgrading its operative system.

OSX comes with a software called "App Store". The upgrade was sold
there, and was prominently advertised as well. If you have ever
installed one application in a smartphone, the procedure was very
similar - downloading the operative system took some time, since it
weighted 4GB.

After the download finished, the computer requested a reboot. I noticed
a couple issues:

-   Mountain Lion comes with a new security "feature" that blocks
    installing software that doesn’t come from the App Store - If OSX
    complains that "the developer is using an unkonwn signature" or
    something similar, activate the corresponding option in
    `Apple Menu > System Preferences > Security & Privacy > Allow Applications downloaded from: Anywhere`.
-   I also noticed later on that the encoding is not set by default.
    This gave me issues later on when I started using ruby and Unicode
    stuff. In order to fix this, you must remember to add the following
    to your .profile/.bashrc/.zshrc:

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

## Install gcc for OSX

Macs come with no compiler installed by default. From what I could
understand, the development environment is called "XCode". It’s a big
download, another 4GB (later on I found some claims that you don’t need
to download the whole XCode; the compiler can apparently be downloaded
separately.

However, I opted for an alternative approach: I used
[gcc-for-osx](https://github.com/kennethreitz/osx-gcc-installer/) .
Installing it is very straightforward; download, double-click business.

## Install ruby

Once the compiler is in place, you can install ruby. The recommended way
to do that is via a ruby version manager. There are two main ones: `rvm`
and `rbenv`. My personal preference is the former.

```bash
curl -L https://get.rvm.io | bash -s stable --ruby
```

Once the process finishes downloading and compiling, it is usually a
good idea to set the default ruby version. At the time of this writing,
it is ruby 1.9.3. So I did this:

```bash
source ~/.bashrc
rvm use 1.9.3 —default
```

Once this is done, you should be able to execute `ruby --version` and
obtain ‘1.9.3’.

I later on installed ruby 1.9.2 since I need it for this blog (which is
done in [octopress](http://octopress.org) , and it does not work in ruby
1.9.3).

```
rvm install 1.9.2
```

## Install homebrew

Homebrew is a tool for installing packages from the command line. I
think of it as an "very limited apt-tools package". But it’s the best
there is on OSX, so you might as well install it. Here’s how you do it:

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

Once homebrew is installed, you can use it to install other useful
packages. For example, git and wget:

```bash
brew install git
brew install wget
```

## Vim

Another thing I needed was a better console, and a decent source code
editor. I am used to Vim in Ubuntu, so the natural choice in OSX is
using [macvim](http://code.google.com/p/macvim/) .

Homebrew has a recipe for installing vim, but it doesn’t work if you
have installed gcc instead of XCode, as I’ve done. So I had to download
it from the website, and manually create a couple aliases .

I’m very happy to report that
[Adegan](https://github.com/kikito/adegan), my custom Vim configuration,
seems to have work very well in macvim. To install it I had to use the
same command I use in Ubuntu:

```bash
curl -Lo- https://raw.github.com/kikito/adegan/master/scripts/bootstrap.sh | bash
```

## iterm2 and zsh

The default terminal emulator is quite alright, but since I was
experimenting, I decided to install it’s "cool replacement",
called [iterm2](http://www.iterm2.com). Again, this was a matter of
downloading and double clicking, and then dragging to the Applications
folder. Oh, and sticking it into the Dock.

Then I installed zsh, a replacement for bash. I did so from brew:

```bash
brew install zsh
```

Then I had to tell iterm2 to use zsh by default. That is done via this
command:

```bash
chsh --s /bin/zsh
```

Next time a console is opened, it will use zsh instead of bash.

I then installed ohmyzsh:

```bash
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
```

It seems that the version I installed by default sets the theme
to `"random"`. I edited the `~/.zshrc` file and set it to `"robbyrussell"`,
which I’m used to.

## Overall experience

I find that, in terms of installation and configuration, OSX is
intermediate. It is not as bad as Windows, where each piece of software
is installed and updated independently, but it is also not as pleasant
as Ubuntu, where almost everything is centralized via apt.

I found that some applications required "double clicking" to be
installed, others had to be "extracted and copied to the Applications
folder", while others had an "special window" where you could drag the
application icon to applications. And then there is the App Store, and
Homebrew.

I am also adapting to the US keyboard layout, and doing some
experiments. I might post about that soon.
