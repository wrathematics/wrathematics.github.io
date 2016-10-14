---
layout: post
comments: true
title: 'Project Euler in R:  Problem 10'
date: 2011-08-26 23:52:58.000000000 -04:00
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


**Problem:** Find the sum of all the primes below two million.

**Commentary:** If you're not careful, this problem can really get you
in R. In poking around the internet, there are a few solutions to this
problem, but all the ones I've tested are slow. Some, even from people
who are better at R than me, are [VERY
slow](http://www.theresearchkitchen.com/blog/archives/175). That linked
one in particular took 6 minutes and 8.728000 seconds to complete. My
solutions runs in under 2 seconds.

So we'll be using that [old prime
algorithm](http://librestats.wordpress.com/2011/08/19/project-euler-in-r-problem-7/ "Project Euler in R:  Problem 7")
I've already discussed to death. Other than a few tricks in there that I
never see get implemented, there's a crucial trick to this solution.
Since we only want the sum, let's not be slow about finding the primes
we want. I only have to find all primes below \$latex \\sqrt{n}\$, where
\$latex n=2000000\$. It takes basically no time to find them. From
there, I start evaluating my sum, and like a good little R user, I
vectorize by getting the possible list of possible primes above \$latex
\\sqrt{n}\$. From there, I check if any of my known primes divide into
those possible primes. This is actually much faster than generating
primes and storing them.**
**

**R Code:**

```RElapsedTime <- system.time({
##########################
n <- 2000000

### Function to get primes below specified n; option to get only
those below sqrt(n)
PrimesBelow <- function(n, below.sqrt=FALSE){
if (below.sqrt == TRUE){
m <- ceiling(sqrt(n))
} else {
m <- n
}

primes <- c(2,3)
i <- 3
while (i < m-1){
flag <- 0
i <- i+2
if (i%%6 == 3){
flag <- 1
}
if (flag == 0){
s <- sqrt(i)+1
possible.primes <- primes[primes<s]
for (prime in possible.primes){
if ((i%%prime == 0)){
flag <- 1
break
}
}
if (flag == 0){
primes <- c(primes, i)
}
}
}
primes
}
###

primes <- PrimesBelow(n, below.sqrt=TRUE)

biglist <- ceiling(sqrt(n)):n
biglist <- biglist[-which(biglist%%2 == 0)]
biglist <- biglist[-which(biglist%%6 == 3)]

for (prime in primes){
biglist <- biglist[which(biglist%%prime != 0)]
}

answer <- sum(primes)+sum(as.numeric(biglist))
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("
The answer is: %f
Total elapsed time: %d minutes and
%f seconds
", answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 142913828922.000000
Total elapsed time: 0 minutes and 1.915000 seconds
