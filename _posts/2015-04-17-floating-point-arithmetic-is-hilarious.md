---
layout: post
comments: true
title: Floating Point Arithmetic Is Hilarious
date: 2015-04-17 18:48:43.000000000 -04:00
type: post
published: true
status: publish
categories:
- Math
tags:
- Computer Science
- Math
- Programming
author: wrathematics
---


I'm torn about talking about [floating point numbers](https://en.wikipedia.org/wiki/Floating_point) out in the open.  I feel like this is the sort of thing that should be hidden away from polite society, so as not to scare the children. It's just indecent!

[![From SMBC Comics]({{ site.baseurl }}/assets/robot_internet.png)](http://www.smbc-comics.com/index.php?id=2999)
[From SMBC Comics](http://www.smbc-comics.com/index.php?id=2999)

A few years ago, I picked up the book *Handbook of Floating Point Arithmetic*, by Muller et al, which is *fantastic*.  Chapter 7 alone is worth the price of admission for me, so I definitely recommend this one if you're interested in this sort of thing.  In the first chapter, the authors present a beautiful example originally due to the mathematician Jean-Michel Muller (one of the book's coauthors), almost as a throwaway.  I was previously unaware of this example, and as much as I like the book, it doesn't really go into any detail for this deeply interesting, somewhat amazing example.  So I will present an explanation here. 

Frankly, I'll take any excuse to use my advanced math degree for something other than kindling.

An Interesting Sequence
=======================

We're going to define a sequence of numbers: 

-   $$ x_0 = 2 $$
-   $$ x_1 = -4 $$
-   $$ x_n = 111 - \frac{1130}{x_{n-1}} + \frac{3000}{x_{n-1}x_{n-2}} $$   whenever   $$ n > 1 $$

I'm going to state without proof that this sequence of numbers converges to a finite real number...an integer even!  So what does it converge to?  Well, this looks kind of hard, so let's fire up the old computing machine and see what it has to say.  In R, we might try computing, say, the n=90'th element of this sequence as follows:

```R
x0 <- 2
x1 <- -4

n <- 90
for (i in 1L:n){
  tmp <- 111 - 1130/x1 + 3000/x0/x1
  x0 <- x1
  x1 <- tmp
}

print(x1)
## [1] 100
```

Which might suggest that the limit is 100.  To help further convince ourselves, here are the first 25 values of the sequence computed as above:

```
2
-4
18.5
9.378378
7.801153
7.154414
6.806785
6.592633
6.449466
6.348452
6.274439
6.218696
6.175845
6.142491
6.118039
6.129993
6.652921
14.71101
64.83933
96.71745
99.79487
99.98759
99.99925
99.99995
100
```

And indeed, if we try higher values of n, we will always get 100 back. And that's all perfectly well and good, except that the limit isn't 100.  Not even close;  in fact, the limit is 6. 

A Closed Form for the Recurrence
================================

An ancient trick for this kind of thing at least as old as your mom is to let $$ x_n = \frac{y_{n+1}}{y_n} $$.  Then from the definition of $$ x_n $$ and some high school algebra, we have

$$ y_{n+1} = 111 y_n - 1130 y_{n-1} + 3000 y_{n-2} $$

So the characteristic polynomial of this (now linear) recurrence relation is

$$ p(t) = t^3 - 111 t^2 + 1130 t - 3000 $$

Which factors as

$$ p(t) = (t-5)(t-6)(t-100) $$

[Therefore](https://en.wikipedia.org/wiki/Recurrence_relation#Linear_homogeneous_recurrence_relations_with_constant_coefficients), we know that the closed form to the original recurrence is just:

$$ x_n = \displaystyle\frac{\alpha 5^{n+1} + \beta 6^{n+1} + \gamma 100^{n+1}}{\alpha 5^n + \beta 6^n + \gamma 100^n} $$

where $$ \alpha, \beta, \gamma $$ depend on the initial values and are not all zero.  We may choose $$ \gamma=0 $$, and so to satisfy our initial values, we could take $$ \alpha=4 $$ and $$ \beta=-3 $$.  So the above simply reduces to:

$$ x_n = \displaystyle\frac{4\cdot 5^{n+1} -3\cdot 6^{n+1}}{4\cdot 5^n -3\cdot 6^n} $$

If staring at the closed form and taking the limit doesn't do it for you, we can evaluate the closed form for n=90:

```R
n <- 90
(4*5^(n+1) - 3*6^(n+1)) / (4*5^n - 3*6^n)
## [1] 6
```

and we do indeed get 6.  Not 100.  What's going on here?

Precision and Error
===================

The reason for the discrepancy is due to rounding in floating point calculations. This is the kind of stuff that a numerical analysis nerd has been saving up for ages and can't wait to throw in your face, [like how you shouldn't fit a linear model numerically by solving the normal equations because it squares the condition number](https://www.youtube.com/watch?v=gZEdDMQZaCU). The reason the behavior is so drastic in this particular case is interesting, and we'll save for last.  But for the moment, it's worth talking a bit about precision.  Now, as I plugged at the beginning, there are lengthy books written about this sort of thing. If this simple exercise isn't enough for you, then I would recommend you check out that book.

#### A Simpler Example

In R, we were using the "numeric" type, which is just ordinary, [standards-conforming](https://en.wikipedia.org/wiki/Double-precision_floating-point_format#IEEE_754_double-precision_binary_floating-point_format:_binary64) double precision.  A double stores 15-ish significant decimal digits.  There are lots of great reasons to use floating point arithmetic, not the least of which is our modern processors are very good at doing that sort of thing quickly.  But one of the many uncomfortable facts of life is that if you use the finite collection of double precision numbers as a proxy for all real numbers, you're going to be doing some rounding when you do arithmetic.  And all that rounding can cause problems, as we have seen. I emphasize this point because there are, [quite literally](https://en.wikipedia.org/wiki/Cardinality_of_the_continuum), more total real numbers that we can't represent in finite precision than there are rational numbers that we can't represent in finite precision.  So put that in your pipe and smoke it, pragmatists.

A fairly typical example demonstrating the annoyances of floating point arithmetic goes something like:

> Take away 0.1 from 1.0 a total of 10 times.  What is left?

This simple grade school problem obviously leaves us with the nice round figure of

$$ 1.38777878078144567553\cdot 10^{-16} $$

Observe:

```R
x <- 1.0
for (i in 1:10) x <- x - 0.1
print(x)
## [1] 1.387779e-16
```

#### Increasing Precision

Returning to our original problem, we don't have to restrict ourselves to double precision.  For example, using the closed form version with 100 decimal digits of precision, the n=90'th element of the sequence is:

```
-194484503966606330403063711837983662285570299407728396054933665583977868
DIVIDED BY
-32414083455905343769633226145257243147879650444379139641395906340819228
EQUALS
6.0000000996842706405938640973226994993440715357961998285253498625908424967847311051521508134673925008
```

Which is pretty close to 6 (and would be closer if we increased n).  But using the recurrence relation is a very different story.  The n=90'th element was computed as 100.000000000000000 as a double.  In fact, you aren't likely to get anything different until you have well past 50 decimal digits of precision.  With 110 decimal digits of precision using [bc](https://en.wikipedia.org/wiki/Bc_%28programming_language%29) on this particular machine with the recurrence relation version, we get:

```
6.00172389695542688970915241459836912550339070630209747923301192325824948631011408117384086764712277009329983190
```

Why?
====

Rounding error or not, this is a pretty weird example, right?  Throwing your hands up in the air and saying "floats are broken, the world is doomed" doesn't really answer the question as far as I'm concerned.  We can compute some things quite reliably in floating point arithmetic; why not this?

Notice that the zeros of the characteristic polynomial above are fixed points for the operator

$$
F\left(\left[\begin{array}{l}u\\v\end{array}\right]\right) =
\left[\begin{array}{c}111 - \frac{1130}{u} +
\frac{3000}{uv}\\u\end{array}\right]
$$

Indeed:

```R
F <- function(u, v) 111 - 1130/u + 3000/u/v

F(5, 5)
#[1] 5
F(6, 6)
#[1] 6
F(100, 100)
#[1] 100
```

So why look at this operator?  Because

$$
F\left(\left[\begin{array}{l}x_{n-1}\\x_{n-2}\end{array}\right]\right)
= \left[\begin{array}{l}x_n\\x_{n-1}\end{array}\right]
$$

And we can learn something very interesting by studying the eigenvalues of the Jacobian of this operator applied to our fixed points.  The Jacobian is easily shown to be:

$$
J := \left[\begin{array}{cc}
  \frac{\partial F_1}{\partial u} & \frac{\partial F_1}{\partial v} \\[.2cm] 
  \frac{\partial F_2}{\partial u} & \frac{\partial F_2}{\partial v}
\end{array}\right] = 
\left[\begin{array}{cc}
  \frac{1130}{u^2} - \frac{3000}{u^2v} & \frac{-3000}{uv^2} \\[.2cm] 
  1 & 0
\end{array}\right]
$$

And so for our fixed points, we have:

```R
J <- function(u, v) matrix(c(1130/u/u - 3000/u/u/v, 1, -3000/u/v/v, 0), 2, 2)

J(5, 5)
##      [,1] [,2]
## [1,] 21.2  -24
## [2,]  1.0    0

eigen(J(5, 5))$values
## [1] 20.0  1.2

J(6, 6)
##      [,1]      [,2]
## [1,] 17.5 -13.88889
## [2,]  1.0   0.00000

eigen(J(6, 6))$values
## [1] 16.6666667  0.8333333

J(100, 100)
##      [,1]   [,2]
## [1,] 0.11 -0.003
## [2,] 1.00  0.000

eigen(J(100, 100))$values
## [1] 0.06 0.05
```

[There's a well-known theorem in dynamical systems](https://en.wikipedia.org/wiki/Stability_theory#Maps) (holy crap, I can't believe I get to reference this!) that if all of the eigenvalues of the Jacobian evaluated at a fixed point of the dynamical system are (in modulus) below 1, then that point is an *attractor* (which is exactly what it sounds like), but if one or more of the eigenvalues is (in modulus) above 1, then that point is a *repeller* (which is also exactly what it sounds like).  This means that if a point is "close" to 100, then the sequence will very quickly converge to 100, as we have seen.  And while 6 is a fixed point, it is repelling, so you have to sneak up on it (approach it along one particular path) or the sequence quickly runs away from it.  The floating point errors exploit this behavior.

So if you're having float problems, I feel bad for you, son. I got 99 problems but a float ain't 1.00000000000000022204
