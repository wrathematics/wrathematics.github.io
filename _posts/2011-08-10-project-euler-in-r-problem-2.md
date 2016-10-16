---
layout: post
comments: true
title: 'Project Euler in R:  Problem 2'
date: 2011-08-10 22:47:06.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- fibonacci numbers
- golden ratio
- phi
- Project Euler
- R
author: wrathematics
---


**Problem 2:** By considering the terms in the Fibonacci sequence whose
values do not exceed four million, find the sum of the even-valued
terms.

**Commentary:** This problem again is not very tricky. It is worth
mentioning here that I am a mathematician by training, and I'm about to
math the hell out. If you're not into that, you are encouraged to skip
this entire section.

The Fibonacci numbers are governed by the recurrence relation:

$$ F_n = F_{n-1} + F_{n-2} $$

with $$ F_0 = F_1 = 1 $$. What's not stated in the Project Euler
explanation (which will become debatably useful in a later problem), is
that there is a "closed form" to the Fibonacci Numbers, given by:

$$ F_n =
\displaystyle\frac{\left(\frac{1+\sqrt{5}}{2}\right)^{n+1} -
\left(\frac{1-\sqrt{5}}{2}\right)^{n+1}}{\sqrt{5}} $$

(where the exponents "$$ n+1 $$" would be replaced by $$ n $$ if
you index the sequence via $$ F_1=F_2=1 $$). Demonstrating this is
not particularly difficult if you're at all comfortable with simple
calculus (which now qualifies as high school mathematics). To do this,
we'll use a generating function (there are other approaches to get this
"closed form", but this, in my opinion, is by far the simplest). Let's
first construct a funny thing called $$ S $$:

$$ S:= \displaystyle\sum_{n=0}^\infty F_n x^n $$

You might be wondering if this is a sensible definition, i.e., does it
even make sense to say that this arcane construction $$ S $$ even
exists. If so, congratulations, you think like a mathematician--yes, you
too could be a poor man some day! If you never bothered to wonder, then
you lucked out, because that can ultimately be considered an irrelevant
question in the first place. But even the staunchest pedant can be
convinced that this is a reasonable construction--which is a discussion
I don't really feel like having here. Deal with it, nerd.

Ok, so weird thing in hand, let's play with it. Notice that

$$ S = F_0 + F_1x + \displaystyle\sum_{n=2}^\infty F_n
x^n\\= F_0 + F_1x + \displaystyle\sum_{n=2}^\infty
\left(F_{n-1} + F_{n-2}\right) x^n\\=F_0 + F_1x +
\displaystyle\sum_{n=2}^\infty F_{n-1} x^n +
\displaystyle\sum_{n=2}^\infty F_{n-2} x^n\\ = F_0 + F_1x +
x\displaystyle\sum_{n=2}^\infty F_{n-1} x^{n-1} +
x^2\displaystyle\sum_{n=2}^\infty F_{n-2} x^{n-2} $$

and after re-kajiggering the indices (that's the technical way to say
it), and doing a little grouping, we have:

$$ S = F_0 + F_1x + x\displaystyle\sum_{n=1}^\infty F_{n}
x^{n} + x^2\displaystyle\sum_{n=0}^\infty F_{n} x^{n}\\ =
F_0 + \left(F_1x + x\displaystyle\sum_{n=1}^\infty F_{n}
x^{n}\right) + x^2\displaystyle\sum_{n=0}^\infty F_{n}
x^{n}\\= F_0 + xS + x^2S\\=1+xS+x^2S $$

So that

$$ S(1-x-x^2)=1 $$

Hence

$$ S = \displaystyle\frac{1}{1-x-x^2} $$

The last bit just devolves into a bunch of boring arithmetic, so I'll
keep the details fairly simple from here on. Using the method of partial
fractions decomposition, we can further write

$$ S =
\displaystyle\frac{1}{1-x-x^2}\\[.3cm]=\displaystyle\frac{\alpha_1}{1-\beta_1x}+\displaystyle\frac{\alpha_2}{1-\beta_2x} $$

and with only a little elbow grease, you can show that $$
\beta_1=\frac{1+\sqrt{5}}{2} $$, $$
\beta_2=\frac{1-\sqrt{5}}{2} $$, $$ \alpha_1 =
\frac{1}{\sqrt{5}}\beta_1 $$, and $$ \alpha_2 =
-\frac{1}{\sqrt{5}}\beta_2 $$. Of course, these numbers are
themselves quite well studied--typically $$ \beta_1 $$ is written
as $$ \phi $$, and given the interesting name "the golden ratio"
(more on that in a moment). So then

$$ S=\displaystyle\sum_{n=0}^\infty \left(
\alpha_1\beta_1^{n+1}+\alpha_2\beta_2^{n+1} \right)x^n $$

and by merely comparing coefficients among these two series, we have

$$ F_n = \alpha_1\beta_1^n + \alpha_2\beta_2^n $$

which is exactly what we wanted to show!

Of course, the Golden Ratio has many cute properties and ties to the
Fibonacci Numbers. For example,

$$
\displaystyle\lim_{n\rightarrow\infty}\frac{F_{n+1}}{F_n} =
\phi $$

Actually, as it turns out, this limit shows up more commonly than you
might expect. But it does give some insight into the funny way some
people define $$ \phi $$--in terms of its so-called continued
fraction expansion. Starting with an example calculation, let's look at
$$ F_5 $$ and $$ F_4 $$. Notice that

$$ \displaystyle\frac{F_5}{F_4} =
\displaystyle\frac{8}{5}\\=1+\displaystyle\frac{3}{5}\\=1+\displaystyle\frac{1}{\frac{5}{3}}\\=1+\displaystyle\frac{1}{1+\frac{2}{3}}\\=1+\displaystyle\frac{1}{1+\frac{1}{\frac{3}{2}}}\\=1+\displaystyle\frac{1}{1+\frac{1}{1+\frac{1}{2}}}\\=1+\displaystyle\frac{1}{1+\frac{1}{1+\frac{1}{1+\frac{1}{1}}}} $$

So you might be inclined to think that

$$ \phi =
1+\displaystyle\frac{1}{1+\frac{1}{1+\frac{1}{1+\frac{1}{\ddots}}}} $$

And you would be right!

Now where were we? Oh right; that R thing. This closed form is easy
enough to implement in R to give you the Fibonacci Number of your choice
without having to compute all prior ones--but it's not terribly
efficient about it:

```R
GetNthFib <- function(n){
  1/sqrt(5)*(((1+sqrt(5))/2)^{n+1} - ((1-sqrt(5))/2)^{n+1})
}
```

One final word before the R Project Euler solution: the Project Euler
people use the indexing $$ F_1=F_2=1 $$, and then define the
recurrence relation for all $$ n>2 $$. This is fine (and all R
code beyond this point is a reflection of their choice), but it is worth
noting that combinatorists--the people who have the most claim to that
dumb list of numbers, generally agree that it should be indexed as
$$ F_0=F_1=1 $$.

**R Code:**

```R
ElapsedTime<-system.time({
##########################
### Function to get a vector of all Fibonacci #'s below n
FibsBelow <- function(n){
  fib <- c(1, 1)
  i <- 2
  while (sum(tail(fib, 2)) < n){
    i <- i+1
    fib[i] <- fib[i-1]+fib[i-2]
  }
  fib
}
###
n <- 4*10^6
 
fib.numbers<-FibsBelow(n)
answer<-sum(fib.numbers[-which(fib.numbers%%2 == 0)])
##########################
})[3]
ElapsedMins<-floor(ElapsedTime/60)
ElapsedSecs<-(ElapsedTime-ElapsedMins*60)
cat(sprintf("\nThe answer is:  %d\nTotal elapsed time:  %d minutes and %f seconds\n",answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 4613732
Total elapsed time: 0 minutes and 0.001000 seconds
