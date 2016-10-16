---
layout: post
comments: true
title: 'Project Euler in R:  Problem 4'
date: 2011-08-17 10:51:52.000000000 -04:00
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


**Problem 4:** Find the largest palindrome made from the product of two
3-digit numbers.

**Commentary:** Believe it or not, I don't have much to say about this
problem. There are cuter, more general ways to attack this problem, but
computer scientists suffer from an acute case of overgeneralizationitis.
I had a math professor once who loved to say "never do a calculation
before its time". This is good advice, even in programming, but I think
there's a useful addendum to this. Never generalize before it's
necessary. Encapsulating an idea into a function is a stupid waste of
time unless you're pretty sure there's a good reason to do it. But in my
experience, most programmers don't bother thinking much about anything.
They literally behave like computers, as though some algorithm needs to
be fed to them and that is then all they are capable of doing from that
point forward.

My biggest problem with programmers is they have this mindset that
there's only one possible solution. I hesitate to say this of computer
scientists in general, but it's certainly true of people who call
themselves programmers: these people lack imagination. They talk about
"right" and "wrong" solutions, when what they really mean is "good" and
"bad", or more often, "elegant" and "inelegant", a completely
subjective, ill-defined notion.

What's especially sad about this is that the entire field exists because
of mathematicians and logicians. Ask a computer scientist about the
halting problem and he'll go on and on about it; ask him about Goedel
incompleteness and he'll scratch his head and stare at you blankly.
What's even funnier about this is that they even stole the concept of
"elegance" in a solution from the mathematicians. But in their theft,
they managed to get something very wrong. We don't throw away an idea
just because a more elegant one comes along. Sometimes beautiful,
elegant solutions give you *absolutely no insight* into *why* a thing is
the way it is, when the clunky, inelegant one will.

I'm not advocating that we make every proof (or program) into a brutal
slog of calculations and appeals to first principles. But elegance
without insight can be very costly.

And that is why programmers are terrible at mathematics.

**R Code:**

```R
ElapsedTime <- system.time({
##########################
RearrangeVector <- function(vec, n=1){
  vec <- c(tail(vec, length(vec)-n), head(vec,n))
  vec
}
 
palindromes <- numeric(9*10*10)
i <- 1
for (a1 in 1:9){
  for (a2 in 0:9){
    for (a3 in 0:9){
      palindromes[i] <- a1*10^5 + a2*10^4 + a3*10^3
                          + a3*10^2 + a2*10^1 + a1
      i <- i+1
    }
  }
}
 
palindromes <- sort(palindromes, decreasing=TRUE)
 
prod <- numeric(0)
temp <- 899:999
for (n in 1:100){
  prod <- c(prod, temp*RearrangeVector(temp, n))
}
 
acceptable <- palindromes[palindromes %in% prod]
 
answer <- acceptable[1]
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("\nThe answer is:  %d\nTotal elapsed time:  %d minutes and %f seconds\n",
answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 906609
Total elapsed time: 0 minutes and 0.011000 seconds
