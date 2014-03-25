---
title: Typing Spanish letters in a US mac keyboard
---

I have already mentioned that I’ve [purchased a new Mac Book Air](/blog/2012/07/26/bootstrapping-a-mac-for-development/). I’m still adapting to it, but I wanted to share some of the things I learned from that adaptation. One of the things I’m learning to cope with is the U.S. keyboard layout that I picked.

<!-- MORE -->

The U.S. layout is great for what I do most of the time: I either program, or write in English.

But I am from Spain. Sometimes I must interact in Spanish. That foolish language contains all the English glyphs, and then adds all these: áéíóúüÁÉÍÓÚÜ¿!ñÑ.

The U.S. layout is capable of producing them, but it isn’t a great experience.

I enquired some mac-savy colleages who where in the same situation I was, and they basically gave me two options:

* I could “switch” between the U.S. and Spanish layout, when I needed to write either language.
* I could also keep the U.S. layout only, and “jump through its hoops” when I needed to produce Spanish letters. In other words, “man up”.
* I dismissed the first option right away. I didn’t want to keep switching layouts. That is not operative for me.

I gave the second option a try and, as it can be inferred from the text above, the results were not great. I felt like I needed too many keystrokes to produce characters that, when I’m writing in Spanish, are fairly common. And I have other places to “man up” first (for example, the 20-or-so basic movement commands in vim).

So, none of the options given was satisfying. I had to produce a third option.

And I did! Ladies and gentlemen, let me give you:

## [us-4-es.keylayout](https://github.com/kikito/us-4-es.keylayout)

This keyboard layout is especially thought for people in my same situation; people with a US layout who need to write in Spanish from time to time, and who don’t want to keep switching layouts.

It behaves exactly like the default U.S. layout on “normal” and “uppercase” mode. So when writing in English or programming, your keyboard will feel the same.

Changes affect the “alt-mode” though. Some of the keys work differently when the “option key” is pressed. For example, “option-a” will produce “á”, “option-e” will produce “é”, and so on.

You might find a list of all the modifications and instructions on how to install in the [project’s github page](https://github.com/kikito/us-4-es.keylayout).

Please feel free to contact me if you have any questions/suggestions. If you find any issues, please [create an issue on github](https://github.com/kikito/us-4-es.keylayout/issues/new) instead.
