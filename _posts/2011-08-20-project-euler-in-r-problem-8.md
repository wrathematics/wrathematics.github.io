---
layout: post
comments: true
title: 'Project Euler in R:  Problem 8'
date: 2011-08-20 00:57:42.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- Project Euler
- R
- Shell Scripting
author: wrathematics
---


**Problem:** Find the greatest product of five consecutive digits in the
1000-digit number.

**Commentary:** So this solution is probably a little non-standard. I've
actually got a huge blog post coming up about the little "trick" I use
here, so I won't go into it at length just yet. But before we go into
the "trick", I want to explain why it is that I'm doing the weird crap
that I'm doing--afterwards we'll talk a little about the "what".

My philosophy on Project Euler problems is that they should be taken "as
is". If I'm given a text file (as is the case in some problems), then
I'd better figure out how to read in that text file. Likewise, if I'm
given a text dump (as is the case here), then no changes can be made by
hand. None at all. I suspect this is how most people proceed. However,
after solving a problem in Project Euler, I enjoy looking at other
people's solutions, and in doing so, I have found some people who admit
to doing some truly crazy things. Things like adding commas after
characters by hand in a huge text dump. Don't do that!

So in this problem, the goal is to copy/paste the text dump in a script
and sandwich it somewhere between some usable code. I do this by turning
it into a vector in R using Unix sorcery. Once you buy that this is what
I've done, the rest is trivial. Just check every 5 consecutive digits,
but keep only the biggest.

**R Code:**

```R
ElapsedTime <- system.time({
##########################
big <- "
73167176531330624919225119674426574742355349194934
96983520312774506326239578318016984801869478851843
85861560789112949495459501737958331952853208805511
12540698747158523863050715693290963295227443043557
66896648950445244523161731856403098711121722383113
62229893423380308135336276614282806444486645238749
30358907296290491560440772390713810515859307960866
70172427121883998797908792274921901699720888093776
65727333001053367881220235421809751254540594752243
52584907711670556013604839586446706324415722155397
53697817977846174064955149290862569321978468622482
83972241375657056057490261407972968652414535100474
82166370484403199890008895243450658541227588666881
16427171479924442928230863465674813919123162824586
17866458359124566529476545682848912883142607690042
24219022671055626321111109370544217506941658960408
07198403850962455444362981230987879927244284909188
84580156166097919133875499200524063689912560717606
05886116467109405077541002256983155200055935729725
71636269561882670428252483600823257530420752963450
"

big <- as.numeric(strsplit(gsub("\n", "", big), split="")[[1]])

big.prod <- 1
 
for (i in c(1:(length(big)-5))){
  test <- prod(big[i:(i+4)])
  if (test > big.prod){
    big.prod <- test
  }
}
 
answer <- big.prod
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("\nThe answer is:  %d\nTotal elapsed time:  %d minutes and %f seconds\n",
answer, ElapsedMins, ElapsedSecs))
```

**Output:**

The answer is: 40824
Total elapsed time: 0 minutes and 0.002000 seconds
