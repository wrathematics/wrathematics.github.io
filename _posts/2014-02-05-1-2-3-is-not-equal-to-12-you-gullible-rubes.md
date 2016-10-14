---
layout: post
comments: true
title: 1 + 2 + 3 + ... is not equal to -1/12, you gullible rubes
date: 2014-02-05 22:12:57.000000000 -05:00
type: post
published: true
status: publish
categories:
- Math
tags:
- Math
- Math Mistakes
- Misc
author: wrathematics
---


For some reason, a relatively uninteresting observation of Ramanujan has become a bit of an internet celebrity among factoids lately.  Someone who's out to generate link bait makes a post stating that

$$ 1+2+3+\dots = \frac{-1}{12} $$

Now look.  I appreciate trolling as much as the next jerk, but people who really ought to know better are getting tricked by this.  In the usual sense of convergence, this clearly diverges; if it isn't obvious to you that the limit of the partial sums of the left hand side does not converge as a sequence, then you have some serious explaining to do. So when people make this claim, they're referring to something else.

I've summarized the typical proof of this result [in this pdf](http://librestats.com/wp-content/uploads/2014/02/dumbsum.pdf).  Throughout, I basically lie to your face and hope you buy it. For example, let's take a look at one of the preliminaries for the main result in this pdf, that

$$ \sum_{k=0}^\infty (-1)^k = \frac{1}{2} $$

The gist of the argument is if you call the thing on the left A, then (dubiously)

$$ 1-A = 1-(1-1+1-...) = 1-1+1-1+1+... = A. $$

And so 2A=1, or A=1/2.  But then you could just as easily argue as Leibniz did 400 years ago that

$$ 0 = (1-1) + (1-1) + ... = 1 + (-1 + 1) + (-1 + 1) + ... = 1 $$

So A is 0, 1, and 1/2, right?

Where people got the idea for this foolery isn't actually unreasonable (they just present it that way). The original idea comes from one of Ramanujan's notebooks.  In the middle of writing this, I discovered that a [Fields Medal winner wrote about this 4 years ago](http://terrytao.wordpress.com/2010/04/10/the-euler-maclaurin-formula-bernoulli-numbers-the-zeta-function-and-real-variable-analytic-continuation/), and he gives a very good modern explanation for the behavior. But if you don't have a good analysis background, I guess it isn't the easiest read, so let's instead just work from a definition of Ramanujan.  In [Chapter 6 of the first book of "Ramanujan's Notebooks"](http://www.plouffe.fr/simon/math/Ramanujan%27s%20Notebooks%20I.pdf), he defines a "constant" of a series

$$ \sum_{n=0}^\infty a_n $$

(convergent or otherwise) as:

$$ c := \frac{-1}{2}f(0) - \sum_{n=1}^\infty \frac{B_{2n}}{(2n)!}f^{(2n-1)}(0) $$

which comes from [a fancy pants thing you probably don't care about](https://en.wikipedia.org/wiki/Euler%E2%80%93Maclaurin_formula).  Here f is a "nice" function that (among other things) satisfies

$$ f(n) = a_n $$

for each n, and the $$ B_{2n} $$'s are the even Bernoulli numbers.  The Bernoulli numbers are fiddley, but we won't need many of them to replicate the result.  It turns out that $$ B_2 = \frac{1}{6} $$, and letting $$ f(t) = t $$, we have that the constant of the series $$ \sum_{n=0}^\infty n $$ is

$$ \left(\frac{-1}{2}\cdot 0\right) - \left(\frac{B_2}{2!}\cdot 1\right) = \frac{-1}{12} $$

Now get off my lawn, you hooligans.
