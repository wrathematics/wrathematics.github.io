---
layout: post
comments: true
title: Some Quirks of the R Language
date: 2012-08-14 23:31:08.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Programming
- R
- R Quirks
author: wrathematics
---


R is my favorite programming language.  It's just so useful for getting work done.  Sometimes people will complain that R is a difficult language.  To me, this begs the questions:  difficult for what?  And for whom?  I personally think R is just about the easiest thing in the world for prototyping.  Meaning if you want to quickly crank out some result, R is king.  Now when you get into optimization, interfacing R to foreign languages, parallel computing, or god help you, parallel computing in foreign languages that R interfaces to, things get hard.  Really hard.  But if you just need to get in, analyse and visualise your data, and get on with your life, it really doesn't get much easier than R.  Now, that doesn't mean that R is without its problems.  It's quirky as all hell.  You have probably seen [Ross Ihaka's example of a particular function](http://andrewgelman.com/2010/09/ross_ihaka_to_r/) having a variable which is randomly local or global.  I emphasise *particular* function, because I have actually heard people ascribe this *particular* function's interesting proprty as something common to all R functions.  And, uhh, no.

If you've never taken the time to think about his example, I guess I'll spoil the fun for you.  So here's a quick recreation of his function and some runs of it:

```R
x <- 0
f <- function(.)
{
  if (runif(1) > .5)
    x <- 1

  return(x)
}
sapply(1:10, f)
## [1] 1 0 1 1 0 0 1 1 0 1
x
## [1] 0
```

So just what is that function doing?  You can think of the 'if' statement as basically being if (coinflip=='tails').  So we call the function, and flip a coin.  If 'heads', the 'if' does nothing and moves on.  The only thing left to do in that case is return 'x', which wasn't defined within inside f's scope.  So f shrugs its proverbial shoulders and assumes you must have been talking about that x you declared before you even started talking about f, and so in that case f returns 0.  On the other hand, if the coinflip results in a 'tails', then the 'if' statement declares x to be 1 --- but this only happens within f's scope.  So locally, f assigns the value of 1 to x, and in this case it returns 1.  Afterwards we can check that the x that had nothing to do with f is still 0.

Beauty really is in the eye of the beholder, friends.  Ihaka calls this 'ugly', something 'no sensible language would allow'.  I resoundingly,  categorically, emphatically disagree.  I think this is really beautiful, elegant even.  And to me, it quite nicely demonstrates R's very simple concept of scope.  An object is global, unless it isn't.

Now, say you don't really care about that.  Ok fine, jerk.  How about this?  Sometimes R's quirkiness leads to some interesting expressive power.  For example, when defining function defaults, you can express argument defaults as parameters that are defined within the function scope:

```R
f <- function(x=y)
{
  y <- 0

  return( x )
}
```

Here, a call to f() will return 0, because f() evaluates with the default x=y.  It doesn't matter that y isn't defined at the time f is called, because R does no calculation before its time, and at the beginning of f's scope, it doesn't need to know what x is.  So why ask?  There's no reason to be nosy.  Now, as we chase through function scope, we define y, then demand for the return of x.  At this point, we need to know what x is, because hey, you asked for it.  So we remember that we  wanted x to be equal to the now-defined y.  And so R returns 0 without segfaulting.  Of course, if we really wanted, we could call f(1), which will return 1, because x is equal to y, unless of course it isn't.  This handy trick gets used in core R here and there; off the top of my head, it gets used in svd()/La.svd().  I'm sure I remember seeing it elsewhere, but it's not extremely common.

Of course, R has other quirks that are less useful...annoying ones, even.  Probably everyone has run into this one:

```R
x <- factor(c(1,3,5))
x
## [1] 1 3 5
## Levels: 1 3 5
as.numeric(x)
## [1] 1 2 3
```

If you haven't run into this one before, count yourself lucky.  One of the ways you can get around this is by first casting x as a character, and then casting it as numeric, like so:

```R
as.numeric(as.character(x))
## [1] 1 3 5
```

I'll be honest; I hate this.  Like, a lot.  At one point I remember reading a convincing argument for this behavior, but the behavior itself enrages me so much that I forced this argument from my brain so that I could once again enjoy maximum rage.

I'll close with something that makes basically no sense to me.  I found this adorable little thing one day when I was fiddling around with strings in R:

```R
x <- 1:10
as.character(x)
## [1] "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
as.character(list(x))
## [1] "1:10"
```

Which strikes me as odd.  We can force it to return a vector for us...sort of.  So seemingly, when you declare something like "x<-1:10", R doesn't allocate that vector until it needs to.  This is further suggested by the following:

```R
system.time(x <- 1:1e8)
## user system elapsed
## 0.040 0.076 0.116
system.time(x <- x+0)
## user system elapsed
## 0.192 0.196 0.392
system.time(x <- x+0)
## user system elapsed
## 0.124 0.156 0.282
```

When you tell R to add 0 to x and store the result in x, one of the things it does is farm off the work of actually adding 0 to x to a C function, which takes some work to perform, even though this operation isn't mathematically interesting.  But that isn't all that it does; note the sharp dropoff in runtime when running the operation again.  The runtime is basically stable after that (i.e., performing the addition "x+0" after the first time takes roughly the same amount of time each time thereafter). Without having dug deeper into the internals, my suspicion is that the time discrepancy is caused by allocation of the vector.

Anyway, this is how we get it to return a vector...sort of:

```R
x <- 1:10
x <- x + 0
as.character(x)
## [1] "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
as.character(list(x))
## [1] "c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)"
```

Now we basically get a vector back instead of a literal "1:10".  But it's more like something you would pass to the parse() function than an actual array (like what you get with as.character(x)).  And there are probably very good reasons for this behavior, but it's still quirky.
