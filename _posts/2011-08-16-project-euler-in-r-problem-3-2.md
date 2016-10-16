---
layout: post
comments: true
title: 'Project Euler in R:  Problem 3'
date: 2011-08-16 23:55:35.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- Primes
- Project Euler
- R
author: wrathematics
---


**Problem:** What is the largest prime factor of the number 600851475143
?

**Commentary:** This problem is not very hard, and there is much less of
interest to say about it than in problems 2 and 25. The only real hitch
is knowing what a prime is and knowing a few things about factorization.

As it turns out, there is a surprising amount of research--even current
day research, regarding factorizations of number-like things. Here,
thankfully, the problem is easy enough. Since we're working in the
integers, we have nice things like the Fundamental Theorem of
Arithmetic, which says that every natural number (1,2,3,...) greater
than 1 can be written as a product of powers of primes, and that
ignoring the order in which you present the factors of that
factorization, that any such factorization is unique.

If you actually managed to read that sentence, then you're probably
thinking "Well of course! That's just how things are!" But you should
know better. One of the most fundamental questions you can ask in any
field, but in particular mathematics, is to ask what a symbol means.
What does "$$ 1 $$" mean, or what does "$$ \cdot $$" (for
multiplication) mean? These are important questions that you've probably
never had to deal with unless you've studied math. As it turns out, such
questions aren't irrelevant--at all.

So what is "$$ 1 $$"? It's a (actually THE) thing which when you
take any other thing--I've forgotten the other thing's name, so let's
call it $$ x $$--take that other thing and do this

$$ x\cdot 1 $$

or this

$$ 1\cdot x $$

then you're guaranteed to "get $$ x $$ back". Well, shit, now we
need to know what "$$ \cdot $$" is. Our friend "$$ \cdot $$"
is a thing which gives you a thing when you use it on two allowed
things. Oh, but it can't give you just any old thing. That would be
ridiculous. We mathematicians are civilized folk, afterall, so there are
rules here. Let's say we have three things--and I've forgotten their
names, so let's just call them $$ x $$, $$ y $$, and $$
z $$. Then the rules of the game are

1.  Whatever $$ x\cdot y $$ is, it had better be a thing
2.  $$ x\cdot (y\cdot z) $$, whatever that is, had better be the
    same thing as $$ (x\cdot y)\cdot z $$
3.  $$ 1 $$ is a thing, and $$ 1\cdot x=x $$ and $$
    x\cdot 1=x $$

Ok, so what is a prime? A prime $$ p $$ is a thing which isn't
$$ 0 $$ (the thing so that when you do $$ x+0 $$ or $$
0+x $$ you get $$ x $$--let's not get into what $$ + $$ is right
now, though...), it also isn't a "unit", meaning that there is no
thing--let's say $$ x $$, so that $$ x\cdot p=1 $$ never
happens and so that $$ p\cdot x=1 $$ never happens. But wait,
there's more! There's one final catch, and it's the biggie. If you have
two things, say $$ x $$ and $$ y $$, and you form a
(potentially) new thing called $$ x\cdot y $$; well, if it turns
out that $$ p $$ divides $$ x\cdot y $$ (meaning there is a
thing $$ z $$ so that $$ x\cdot y = p\cdot z $$), then $$
p $$ had better divide $$ x $$ or $$ p $$ had better divide
$$ y $$.

Wait, did I just say that $$ 1 $$ isn't prime? That's right, it
isn't. It never has been. It never will be. Nobody but crackpots thinks
it is. Deal with it, nerd.

Oh right, primes. So we've talked about $$ 1 $$; what do you think
$$ 2 $$ means? Well, it usually means $$ 1+1 $$, but I don't
want to get into $$ + $$ right now, so let's stick to the numbers
we're familiar with.

I pose a simple question to you. Is $$ 2 $$ prime? The answer is: it
depends (because the question is poorly worded!). Remember what it means
to be primes. First and foremost, it isn't $$ 0 $$--which, and
you're just going to have to trust me, we can check off the list--and it
isn't a unit. So think about the collection of all integers. The
integers are the things that go 1,2,3,..., together with 0 and things
like -1,-2,-3,... . As it turns out, this isn't yet another thing your
gradeschool teacher got wrong. Our old friend $$ 2 $$ is prime in
the integers. But what about the collection of all rational numbers--the
things which can be written as ratios of integers. Is $$ 2 $$ prime
in this collection? Nope! Well, not so long as you believe that $$
\frac{1}{2} $$ is a thing (in the collection of rational numbers).
Because if it is, then $$ 2\cdot\frac{1}{2}=1 $$, which means that
$$ 2 $$ is a unit in the rationals. Which means, by definition, it
can't be prime.

So now that no one is confused, let's return to the original problem.

The R code here isn't something I'd probably do over again, but this was
the first solution (which I did slightly clean up post hoc, but the
integrity of the dumbness was kept in tact). The key here is realizing
that any natural number $$ n $$ can have at most one prime divisor
greater than $$ \sqrt{n} $$. Indeed, if it had two such, say
$$ p $$ and $$ q $$ with $$ p \neq q $$, then since $$
p $$ divides $$ n $$ and $$ q $$ divides $$ n $$, by virtue
of being prime (actually all we need is $$ gcd(p,q)=1 $$, which we
certainly get from primality) we would have the product $$ p\cdot
q $$ dividing $$ n $$ (note that this is the part of the argument
that fails if the divisors aren't prime; for example, 100 has several
divisors greater than $$ \sqrt{100}=10 $$, namely 20, 25, and 50.
Of course, none of these is prime...but that was my whole point). The
easiest way to convince yourself that this is so is to think about the
"general" prime factorization of $$ n $$ (see the Fundamental
Theorem of Arithmetic). So by definition of division in the integers,
that means there exists some natural number $$ k $$ with $$
k\geq 1 $$ and $$ n=p\cdot q\cdot k $$. But then

$$
\begin{align*}
n &= p \cdot q \cdot k \\ 
    &> \sqrt{n} \cdot \sqrt{n} \cdot k \\ 
    &= n \cdot k \\ 
    &\geq n \cdot 1 \\ 
    &=n
\end{align*}
$$

In short, we have shown that under the assumption that $$ n $$ has
two prime divisors each of which larger than $$ \sqrt{n} $$, we are
able to conclude that $$ n>n $$, which is absurd. So that
original assumption must not have been a very good one; in other words,
it's not true.

The above will be useful in later problems. Basically, all of the above
is necessary to know if you're in the game of prime finding.

So now that we've made the observation, all that remains is the code for
the solution. There's lots of fussing around to do depending on a couple
of things that could happen, but don't lose sight of the forest for the
trees. The algorithm basically goes like this: Let's say that big old
number is $$ n $$. Then we should

-   Check the odd integers from 3 up to $$ \sqrt{n} $$ to see if
    they divide n, stow these away in a list
-   Take the smallest entry from this list, say $$ k $$, and replace
    $$ n $$ with $$ \frac{n}{k} $$. Make sure $$ k^2 $$
    doesn't divide $$ n $$; also $$ k^3 $$, ...
-   Get your new upper bound, $$ \sqrt{n} $$ (where $$ n $$ is
    really the original number divided by $$ k $$)
-   Continue in this fashion until either $$ n=1 $$, in which case
    the smallest entry in the aforementioned list will be the largest
    prime dividing the original number, or until that smallest entry has
    broken the next upper bound, in which case your winner is
    $$ n $$.

**R Code:**

```R
ElapsedTime <- system.time({
##########################
n <- 600851475143
 
test <- 3
 
if (n%%2 == 0){
  n <- n/2
  test <- 2
}
 
if (n == 1){
  answer <- 2
} else {
  upper.bound <- sqrt(n)
  temp.vec <-
    (test:ceiling(upper.bound))[test:
    ceiling(upper.bound)%%2 == 1]
 
  while (test < upper.bound){
    temp.vec <- temp.vec[n%%temp.vec == 0]
 
    if (length(temp.vec) != 0){
      test <- head(temp.vec, 1)
      n <- n/test
 
      while (n%%test == 0){
        n <- n/test
      }
      upper.bound <- sqrt(n)
      temp.vec <-
        (test:ceiling(upper.bound))[test:
        ceiling(upper.bound)%%2 == 1]
    } else {
      test <- n
    }
  }
  if (n == 1){
    answer <- test
  } else {
    answer <- n
  }
}
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("\nThe answer is:  %d\nTotal elapsed time:  %d minutes and %f seconds\n", answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 6857
Total elapsed time: 0 minutes and 0.050000 seconds

**Final Thoughts:** This solution isn't exactly fantastic. For one, it's
complicated to even look at. The solution provided in the post-solution
commentary for this problem is a bit more elegant, though it feels more
C-ish than R-ish--and my solution is definitely unique to R and its
adorable quirks. Additionally, the arguably more elegant solution (that
provided by Project Euler) doesn't really do a whole lot better
speed-wise. Basically what I'm trying to say is that my solution will
piss off programmers, but who says they don't deserve it?****
