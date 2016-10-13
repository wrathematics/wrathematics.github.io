---
layout: post
title: R Fork Bomb
date: 2011-09-14 22:18:30.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Parallel R
- Programming
- R
author: wrathematics
---


So maybe I'm a strange guy, but I think fork bombs are really funny. 
What's a fork bomb?  The basic premise is that you spawn a process that
spawns a process that spawns a process..., ad infinitum.

The most beautiful example of a fork bomb, and really one of the most
beautiful lines of code ever, was created by [Denis
Rolo](https://secure.wikimedia.org/wikipedia/en/wiki/Jaromil):

```shell
:(){ :|:& };:
```

Aside from looking like the gnarliest smiley face ever, running the
above in a Unix terminal will spawn processes forever, unless you've
limited the number of processes that can be run (I think OS X does this
by default, so any brave Mac users are encouraged to try).  After a
whole lot have been spawned, you've basically locked up your system and
will have to reboot.

There's a thorough explanation of how and why the above code works over
at the [Wikipedia fork bomb
page](https://secure.wikimedia.org/wikipedia/en/wiki/Fork_bomb#Examples),
but I almost feel like knowing how it works ruins the beauty somewhat. 
But that page also has lots of examples of fork bombs in various
languages.  Unfortunately, R is absent from that list.  Well I think
that's just a shame.

We could invoke the above (with some modifications due to a weird quirk)
with the system() function.  But that's basically just letting the shell
have all the fun.  However, we can do one better using the [multicore
package](http://cran.r-project.org/web/packages/multicore/index.html):

```R
library(multicore)

while (TRUE) fork()
```

So why would you want to do this?  Well, I think the whole point is that
you wouldn't want to.  It's just neat.

One final remark on this.  I have a good friend with whom I regularly
converse about programming.  He's a hardcore C programmer, and as such,
he finds my struggles with efficiency in R hilarious.  When I told him
that I was going to make a blog post about an R forkbomb, he had a
simple, two word response:

> "Slowest forkbomb."

Who says programmers don't have a sense of humor?
