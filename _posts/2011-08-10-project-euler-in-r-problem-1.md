---
layout: post
title: 'Project Euler in R:  Problem 1'
date: 2011-08-10 21:32:35.000000000 -04:00
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


**Problem 1:** Find the sum of all the multiples of 3 or 5 below 1000.

**Commentary:** This problem is really simple, but why shouldn't it be?
It's the first one. Don't get antsy; these things get harder in a hurry.
The problem is basically a way to get friendly with modular arithmetic
in your language of choice. For us, that's R, which makes things nice
and easy on us. If I want to calculate n modulo m in R, I just use the
syntax

```R

n%%m

```

So we want all the natural numbers i from 1 to 1000 satisfying either

i (mod 3) = 0

or

i (mod 5) = 0

(or both). If you're screwing this one up, it's probably because you're
not paying attention to the careful wording of the problem (*below*
1000).

**R Code:**

```R
ElapsedTime<-system.time({
##########################
answer <- 0

for (i in 1:999){
if ((i%%3 == 0) || (i%%5 == 0)){
answer <- answer+i
}
}
##########################
})[3]
ElapsedMins<-floor(ElapsedTime/60)
ElapsedSecs<-(ElapsedTime-ElapsedMins*60)
cat(sprintf("
The answer is: %d
Total elapsed time: %d minutes and
%f seconds
", answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 233168
Total elapsed time: 0 minutes and 0.002000 seconds

**Commentary:** This is a reasonably good solution, but there is a
better one discussed in the pdf available after you successfully solve
the problem. I won't go into the particulars of that solution, since
that discussion is fully available from Project Euler, but below is a
provided implementation of this idea in R:

```R
SumDivBy <- function(i){
floor(floor(n/i)*(floor(n/i)+1)*i/2)
}

SumDivBy(3)+DumDivBy(5)-SumDivBy(15)
```
