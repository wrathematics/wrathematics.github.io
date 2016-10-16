---
layout: post
comments: true
title: 'Project Euler in R:  Problem 5'
date: 2011-08-17 12:39:52.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- Project Euler
- R
author: wrathematics
---


**Problem:** What is the smallest positive number that is evenly
divisible by all of the numbers from 1 to 20?

**Commentary:** This problem again isn't very difficult. Basically we
just exploit the existence of prime factorizations and construct the
least common multiple (lcm) in the most intuitive way possible. You
might find something a bit strange in this solution, namely in the
prime-y stuff; however, I don't really want to get into that until
[Problem
7](http://librestats.wordpress.com/2011/08/19/project-euler-in-r-problem-7/ "Project Euler in R:  Problem 7").
So I won't. 

**R Code:**

```R
ElapsedTime <- system.time({
##########################
###
# Function to get primes below specified n; option to get only those below sqrt(n)
PrimesBelow <- function(n,below.sqrt=FALSE){
  if (below.sqrt==TRUE){
    m <- ceiling(sqrt(n))
  } else {
    m <- n
  }
 
  primes <- c(2, 3)
  i <- 3
  while (i < m-1){
    flag <- 0
    i <- i+2
    if (i%%6 == 3){
      flag <- 1
    }
    if (flag == 0){
      s <- sqrt(i)+1
      possibleprimes <- primes[primes < s]
      for (prime in possibleprimes){
        if ((i%%prime == 0)){
          flag <- 1
          break
          }
        }
        if (flag == 0){
          primes <- c(primes,i)
        }
      }
    }
  primes
}
 
# Function to get the prime factorization of all integers below
PrimeFact <- function(n){
list <- numeric(0)
for (i in 2:n){
ps <- numeric(0)
for (prime in primes){
p <- 1
while (i%%(prime^p) == 0){
p <- p+1
}
p <- p-1
ps <- c(ps, p)
}
if (length(list) == 0){
list <- data.frame(primes, ps)
} else {
list <- data.frame(list, data.frame(ps))
}
}
list
}
###
 
n <- 20
 
primes <- PrimesBelow(n)
 
list <- PrimeFact(n)
 
expnts <- numeric(0)
for (nump in 1:length(primes)){
temp <- numeric(0)
for (i in 2:n){
temp <- c(temp, list[[i]][nump])
}
expnts <- c(expnts, sort(temp, decreasing=TRUE)[1])
}
 
answer <- prod(primes^expnts)
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("\nThe answer is:  %d\nTotal elapsed time:  %d minutes and %f seconds\n",
answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 232792560
Total elapsed time: 0 minutes and 0.008600 seconds
