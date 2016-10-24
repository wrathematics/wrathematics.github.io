---
layout: post
comments: true
title: How to Make a Bad Password with R
date: 2014-02-24 08:13:25.000000000 -05:00
type: post
published: true
status: publish
categories:
- R
tags:
- Misc
- R
author: wrathematics
---


I have a lot of projects that will take ages to finish (some are in such poor shape that I tuck them away in private repositories, so no one can see my shame).  So sometimes it's nice to just take a weekend and crank out something start to finish, even if it's dumb and no one cares about it and fewer people want it.  Which brings us to the matter at hand.  There's a relatively famous XKCD comic that argues that if you want a password that's easy to remember, you should combine a random set of words together to create a nonsensical, but easily remembered phrase.

![password_strength]({{ site.url }}/assets/password_strength.png)

Panels from the comic [*Password Strength*](https://xkcd.com/936/)

So I created [this dumb thing](https://github.com/wrathematics/xkcdpw). It's an R package which will create this sort of portmanteau password by randomly selecting words from random web scrapes of Wikipedia.  It basically works like this; you have a function password().  Its arguments are:

-   **pw.len**; the number of words to use in the portmanteau password (in the XKCD example, the number is 4).  The default is 4.
-   **min.len**; the minimum length of any given word in the portmanteau.  The default is 4.
-   **max.len**; the maximum length of any given word in the portmanteau.  The default is 12.
-   **language**; exactly what it looks like.  Default is "english"; others which are supported are french, german, italian, polish, portugese, russian, and spanish.  Each of these includes the "native character" spelling, assuming your terminal supports unicode.  So for example, "усский" is an acceptable option for "russian".  I've been told that collection of symbols means "russian", anyway.  If it doesn't, blame the internet.
-   **num.scrapes**; the number of different, random wikipedia pages to pull from.  Increasing this should increase the strength of the password, but it has a hard max of 5, because repeated use with more than that would be rude and is likely to get you ip banned from Wikipedia.
-   **ret.type**; "separate" or "combined".  Determines whether the returned password is, in the case of the former, a character vector with one entry per word (easier to read), or in the case of the latter, a collapsed, camel-case, portmanteau.  Default is "separate".

So for example:

```R
library(xkcdpw)

password()
#[1] "United"  "Species" "Diamond" "Chloe"
password(ret.type="combined")
#[1] "EarlyAccordingElectedPhysicians"
password(num.scrapes=2, language="espanol")
#[1] "Posición" "Millón"   "Origen"   "Enlaces"
```

If you actually want to install this (and before I explain how, I want you to seriously stop and reevaluate your life), probably the easiest way to do this is to use [Hadley's devtools package](http://cran.r-project.org/web/packages/devtools/index.html).  Assuming you have devtools and my package's dependencies installed ([RCurl](http://cran.r-project.org/web/packages/RCurl/index.html) and [XML](http://cran.r-project.org/web/packages/XML/index.html)), then you should just be able to issue:

```R
library(devtools)

install_github(repo="xkcdpw", username="wrathematics")
```

If you're using Linux or the BSD's, this should just work.  Welcome to the good life, player.  I think this will work out of the box on a Mac.  I have no idea if this will work on Windows; how you strange people get anything done amazes me.  At the least, I'm guessing you have to install [Rtools](http://cran.r-project.org/bin/windows/Rtools/) first.  You could also just source all the R scripts like some kind of barbarian (the package contains no compiled code).  This would be simpler if the package were on the CRAN, but I really don't see the point in bothering them with something so stupid (although, at the time of writing, it does pass an R-devel check, which is somewhat amusing).

Now, I really don't want to get into the security issue with this sort of password shema.  It's been done plenty of times before, and it's pretty much just idle theorycrafting, unless you assume your would-be hacker knows what kind of password you use.  And if so, you should seriously reconsider baiting Russian hackers with that sort of information.  But I'm not particularly interested in debating the finer points of the current "meta" of password cracking.  Frankly, as long as you use a variety of passwords, and none of them are on [this list](http://splashdata.com/press/worstpasswords2013.htm), you're probably fine, unless you somehow bother to make yourself a target of interest.  But I will add that, true to the title, the passwords this particular program generates are not very good.  The package doesn't select words completely at random from any given language as you would from, say, a dictionary.  By virtue of being in the same Wikipedia entry together, their usage is probably correlated, weakening the password to [dictionary attacks](https://en.wikipedia.org/wiki/Dictionary_attack).  But hey, it was fun to make.
