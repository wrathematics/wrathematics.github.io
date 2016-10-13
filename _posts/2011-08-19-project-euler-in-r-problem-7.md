---
layout: post
title: 'Project Euler in R:  Problem 7'
date: 2011-08-19 12:47:43.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- Primes
- Project Euler
- R
- R Quirks
author: wrathematics
---


**Problem:** What is the 10001st prime number?

**Commentary:** So it's finally time to discuss my prime-searching
algorithm, as promised back in [Problem
5](http://librestats.wordpress.com/2011/08/17/project-euler-in-r-problem-5/ "Project Euler in R:  Problem 5").
We will find primes in the following way:

1.  2 and 3 are prime
2.  We examine the odd integers (having already discovered the only
    even prime) starting with \$latex i=5\$.
3.  First, check if \$latex i\$ is of the form \$latex 6k+3\$ for some
    integer \$latex k>0\$. If so, then \$latex i\$ can't be prime,
    because then \$latex i=6k+3=3(2k+1)\$, and since \$latex k>0\$,
    \$latex 2k+1 > 1\$ (so \$latex i
eq 3\$). In this case, don't
    even bother proceeding; replace \$latex i\$ with \$latex i+2\$ and
    start over.
4.  Calculate \$latex s(i)=\\sqrt{i}\$. Among all known primes below
    \$latex s(i)\$ (going no further for the same reason as that
    outlined in [Problem
    3](http://librestats.wordpress.com/2011/08/16/project-euler-in-r-problem-3-2/ "Project Euler in R:  Problem 3")),
    check if these primes divide into \$latex i\$. If we find one that
    does, then there is no reason to proceed; \$latex i\$ is not prime.
    Go back to 3. and try again with \$latex i\$ replced with
    \$latex i+2\$. If none of the known primes below \$latex s(i)\$
    divide \$latex i\$, then stop; \$latex i\$ must be prime. Add it to
    the list of known primes.
5.  Repeat this process by replacing \$latex i\$ with \$latex i+2\$
    until we have 10001 primes.

It's nothing fancy, but it works. As for the implementation, believe it
or not, I actually don't construct a list of length 10001 and insert
into it as I gather my primes like a good little R user. See the
post-code commentary for an explanation.

**R Code:**

```R
ElapsedTime <- system.time({
##########################
primes <- c(2, 3)
i <- 3
while (length(primes) < 10001){
flag <- 0
i <- i+2
if (i%%6 == 3){
flag <- 1
}
if (flag == 0){
s <- sqrt(i)+1
for (prime in primes){
if ((i%%prime == 0)){
flag <- 1
break
}
if (prime > s){
break
}
}
if (flag == 0){
primes <- c(primes, i)
}
}
}

answer <- tail(primes, 1)
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("
The answer is: %d
Total elapsed time: %d minutes and
%f seconds
",
answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 104743
Total elapsed time: 0 minutes and 1.191000 seconds

**Post-Code Commentary:** You may notice that I'm not pre-allocating the
prime list and then storing new prime values as I go, like a good little
R user. The reason is that it's actually slower to do it this way.****
Now maybe I'm an idiot and I don't really understand how R does things,
but if I take this algorithm and only modify the prime storage part of
it to include preallocating the list and then injecting into that list
(replacing a 0) as I go, then the time is nearly *a full order of
magnitude* slower. Here's the R code that you would produce if you were
to do what I just described:

```R
primes <- numeric(10001)
primes[1:2] <- c(2, 3)
i <- 3
prime.position <- 3

while (primes[10001] == 0){
flag <- 0
i <- i+2
if (i%%6 == 3){
flag <- 1
}
if (flag == 0){
s <- sqrt(i)+1
for (prime in primes[primes > 0]){
if ((i%%prime == 0)){
flag <- 1
break
}
if (prime > s){
break
}
}
if (flag == 0){
primes[prime.position] <- i
prime.position<-prime.position+1
}
}
}

answer <- tail(primes, 1)
```

So how do the two run? Well, on my work computer (which is a little
slower than my home computer--also don't tell my boss!), the original
"bad R user" code runs in 1.852 seconds. The "better" solution with
pre-fetching the vector runs in 11.100 seconds. That is a 9.248 second
differential, which amounts to a nearly 500% increase in run time!

Of course, there are plenty of times when it's objectively better to
pre-allocate; but as it turns out, this isn't one of them (though I have
no idea why).
