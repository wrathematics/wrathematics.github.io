---
layout: post
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

So how did I get that thing into a vector? You might argue that it was
by cheating. I couldn't disagree more (more on this at the conclusion of
the commentary). I used the function system(), which on a Linux (and
presumably Mac OS X, *bsd, ...) system is a very powerful tool. It's
essentially a wrapper for the very powerful Unix (or Unix-like) shell
which lives under your operating system and makes everything awesome. I
don't know what it does on Windows because I don't give a shit.

So here, I pass off to the shell an echo which contains some unwanted
(additional) line breaks, together with the text dump from Project
Euler. Next, I pipe off to tr and sed to do their voodoo. In short, this
is how they work here:

-   tr -d '
' removes line breaks
-   sed 's/\\\\([0-9]\\\\)/\\\\1\\
/g' adds a line break after every
    numeral
-   sed 's/.\$//' removes last line break

Two additional things: first, the -e's allow me to chain together a
bunch of sed calls at once. This is handy because sed is the Stream
EDitor, which is exactly what it sounds like--and chaining them like
that (as opposed to piping the output to another sed call) is faster
because (here) you only have to read in the stream once. Second, you
might notice that in the tr call, I use 
 for line breaks, but in the
sed call I use \\
 (and \\\\( instead of \\(, \\\\1 instead of \\1,
etc). The reason is that R's system() function is really weird, and
requires extra escaping of characters...sometimes.

Ok, so that unpacks most of it. The last bit is the intern=TRUE part
(default FALSE) captures the output and stores it into a character
vector (as indicated in the help file). So the last little leg of
sorcery is to use as.numeric to use the numbers for my intended purpose.
That's it; show's over. Go home.

So why wasn't this cheating, in my opinion? It's a wrapper that's built
into core R--it's not even an extra package I have to download. In my
mind, this is very clearly in the "not cheating" category, but I have
some other solutions that, whenever I get the time to post the writeups,
blur the line a bit--especially when I start invoking
[bc](http://www.gnu.org/software/bc/).

If you want to argue that there's a "more R-y" way to do it, then I'm
willing to concede (even though I don't know how--I just drop down to
the shell to do my dirty work and have never been left wanting). If you
think it violates the spirit of Project Euler, then I suggest you take a
look at some of the Python kids who practically import entire solutions.

Besides, sed is really, really cool. Deal with it, nerd.

**R Code:**

```R
ElapsedTime <- system.time({
##########################
big <- as.numeric(system("echo '
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
' | tr -d '
' | sed -e 's/\\\\([0-9]\\\\)/\\\\1\\
/g' -e
's/.\$//'",intern=TRUE))

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
cat(sprintf("
The answer is: %d
Total elapsed time: %d minutes and
%f seconds
",
answer, ElapsedMins, ElapsedSecs))

```

**Output:**

The answer is: 40824
Total elapsed time: 0 minutes and 0.014000 seconds
