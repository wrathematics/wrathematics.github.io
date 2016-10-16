---
layout: post
comments: true
title: 'Project Euler in R:  Problem 9'
date: 2011-08-24 11:08:23.000000000 -04:00
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


**Problem:** There exists exactly one Pythagorean triplet for which a +
b + c = 1000. Find the product abc.

**Commentary:** I'm not proud of this solution. Every time I would look
at this solution, I just knew there was something really obvious I was
missing--that I was doing this in the most bone-headed way possible. So
then I finally just gave up and checked the writeup at Project Euler,
and yep, I forgot that Pythagorean Triplets have a very nice
parametrization.

I won't even bother to reproduce the idea here, because the writeup over
at Project Euler is actually very well done. But it is a bit
embarrassing to have a masters in number theory and to forget that
simple fact. Oh well.

**R Code:**

```R
ElapsedTime <- system.time({
##########################
for (a in c(1:333)){
  for (b in c(334:998)){
    test <- a+b+sqrt(a^2+b^2)
    if (test==1000){
      win.a <- a
      win.b <- b
      break
    }
  }
}
 
answer <- win.a*win.b*sqrt(win.a^2+win.b^2)
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("\nThe answer is:  %d\nTotal elapsed time:  %d minutes and %f seconds\n", answer, ElapsedMins, ElapsedSecs))
```

**Output:**

****The answer is: 31875000
Total elapsed time: 0 minutes and 0.460000 seconds
