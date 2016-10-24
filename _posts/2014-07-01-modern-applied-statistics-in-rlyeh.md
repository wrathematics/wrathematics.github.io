---
layout: post
comments: true
title: Modern Applied Statistics in R'lyeh
date: 2014-07-01 01:27:12.000000000 -04:00
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


So you've probably heard of [King James Programming](http://kingjamesprogramming.tumblr.com/); if not, you should check it out because it's great. A quick summary is that someone took the King James Bible and Sussman's *Structure and Interpretation of Computer Programs* (SICP) and used an n-gram babbler to generate new sentences that combine the texts in amusing ways. The generator itself is a Markov Chain, which has a very special place in my heart, as the method itself was [developed entirely out of spite](http://www.americanscientist.org/issues/pub/first-links-in-the-markov-chain/5).

A few months ago, I wanted to play around with this kind of thing myself.  Naturally I went poking around the CRAN looking for a package that would help with this sort of thing.  Surprisingly, I didn't really find much. But then I discovered that the King James Programming author open sourced their code. Nice!...except that it's in Python.

Python?

<span style="text-decoration: underline;">**Disgusting**</span>.

So I built my own library! With blackjack and pointers!

![272742]({{ site.url }}/assets/272742.png)

More specifically, me and [my buddy](https://github.com/heckendorfc) put together a little R package, available on [GitHub](https://github.com/wrathematics/ngram) and the [CRAN](http://cran.r-project.org/web/packages/ngram/index.html).  Package use is described in detail in the vignette.  Almost nothing in the internals of the package is actually done in R itself; even the processed data structure is just a linked list in C, returned to R as an external pointer. In fact, the entire thing can be compiled as a standalone library.  As such, the code contains many mystical incantations, like:

```
sorted[js]->nextword->word.word = sorted[j]->nextword->word.word;
```

Which is clearly an attempt to summon Cthulhu. Which brings us to the real reason I brought you here...

 

Modern Applied Statistics in R'lyeh
===================================

It's just not right that computer scientists are having all the fun.  So I combined the absolute classic, [*Modern Applied Statistics in S*](http://www.amazon.com/Modern-Applied-Statistics-Computing/dp/0387954570/), with the [Complete Works of H. P. Lovecraft](http://www.amazon.com/Complete-Works-H-P-Lovecraft-Collaborations-ebook/dp/B0090U1QIQ/) (I am obviously not the copyright holder of either of these texts, and their use here is meant as parody, which is fair use, please don't sue me ;__;).

So what do you get when you cross these two texts? 

Spooky analysis!

> *The venerable glass was dim from more than one severed head had been removed, so we expect negative correlation at lag 12.*

I'm sure many of us can relate to this:

> *By the spring of 1923 I had secured some dreary and unprofitable magazine work in the social sciences.*

No comment.

> *We can illustrate this for the crabs data, where the first human people had found monstrous ruins left by those brooding, half-material, alien things that festered in earth's nether abysses.*

It's been a while, but I don't think that's how reliability works...

> *At length he began to distinguish clearly between log-survivor curves and cumulative hazards, which differ only by a day.*

Take note, JSS; I would read a lot more statistics papers if they were
written like this:

> *The original paper gave a linear regression for the square root of the area. It is also necessary to account for the phenomenon itself. What gaseous emanation or mineral vapour could have wrought this change in so relatively short a time was utterly beyond us.*

I think this one might actually be correct:

> *The asymptotic relative efficiency (ARE) is the predicted loss, normally the result of the shifting, wind-blown sand.*

I'm going to start using "that is the law" in my package documentation from now on.

> *Now the use of the predict method function for the quasi family may also be supplied in parentheses as a parameter, for example by pnorm and dnorm with only one trial per case, that is the law.*

And finally...take that, SAS!

> *It had learned all things that ever were known or ever would be known on the earth, through the power of S to perform statistical analyses.*
