---
layout: post
title: A No BS Guide to the Basics of Parallelization in R
date: 2012-03-15 20:24:03.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Parallel R
- Programming
- R
author: wrathematics
---


**What is parallelization?**

Parallelization is using multiple processing cores to, hopefully, make
your programs run faster than serial code, which is the use of just one
processing core.

Parallel code is not always faster than its serial counterpart (but if
you're doing it right and you're careful about what you parallelize, it
will be --- remember, that's your goal here).  Don't rush to parallelize
something just because you can.  Look for the serious bottlenecks in
your code.

Think of your code like the checkout line at a supermarket.  The
shoppers are the "component jobs" of the code and the cashier is the
processor.  Usually (universally?), each customer gets one cashier.  But
imagine suddenly you can chop up your shopping cart into 4 pieces and
pass them along to 4 cashiers.  If you're only buying 7 things and
they're all easy to ring up, this is probably dumb, because in the end
the cashiers are going to have to coordinate and tally for final billing
(an inherent sunken time cost to this approach).  On the other hand, if
you're buying half of the entire store and the items are slow to ring up
(like clothing), this kind of cashier scheme might seriously speed
things up for you.  My point is that for some people it makes sense to
send to multiple cashiers, and for some it really doesn't make sense to
do this.  The same is true of your code.

If you are a computer science nerd who wants to write a 100,000 word
dissertation about why this is not an appropriate metaphor, please send
your submissions to <nobodycares@shutupihateyou.org>.

Ok, so that's (kind of) how it works.  So why should you even bother to
learn how to parallelize your code?  Because:

1.  Computers aren't really getting faster, just stuffed full of more
    cores
2.  Other people care about parallel code (i.e., looks good on a resume)
3.  R is slow
4.  Easy way to speed up your code (in my opinion, MUCH easier than Rcpp
    and, usually, vectorization)

Just remember to try basic optimization before you jump to
parallelization.  Slow serial code produces slow parallel code.

 

**How does parallelization work in R?**

There are some things in R which usualy parallelize very naturally. 
These are:

1.  lapply() calls
2.  probably most other "ply" functions
3.  for loops

As hinted at above, don't necessarily just go hog wild and replace every
for loop with a parallel implementation (especially if you're on
Windows, which has issues).  Good candidates for easy parallelization
usually involve many independent calculations (e.g., checking many
models at once and ranking by AIC/BIC/etc, bootstrapping,
cross-validation, monte carlo simulation, ...).  Bad candidates for
parallelization include things that couldn't possibly be bottlenecking
anything, so just leave them alone.  Additionally, some things are, as
far as I'm concerned, immune to parallelization; but I'm dumb, so that's
probably wrong.

As of R version 2.14, your parallel tools are in the parallel package. 
This comes with R, so you don't even have to install it, assuming R is
installed (if you don't have R installed and you are still reading this,
you have some odd priorities in your life).  Just load it up by calling
'library(parallel)' in R.  This package basically merges the old
[multicore](http://cran.r-project.org/web/packages/multicore/index.html)
and [snow](http://cran.r-project.org/web/packages/snow/index.html)
packages, so that you get mclapply() from multicore and the clusterApply
family from snow.  You can also use the
[foreach](http://cran.r-project.org/web/packages/foreach/index.html)
package for parallelization, but I personally don't.  Experiment for
yourself and come to your own conclusions, but for the remainder, I'm
not going to talk about it.

Thankfully, parallelization in R is fairly straight forward.  There are
just a few functions you have to become familiar with, and then you let
your operating system do most of the magic behind the scenes.  The main
workhorses for parallelization in R via library(parallel) are:

1.  mclapply() --- relies on system forking.  Works on any POSIX-like
    operating system (Linux, Mac OS X, etc---basically all but
    Windows).  Usually reasonably fast.
2.  clusterApply(), clusterApplyLB(), etc --- relies on voodoo. 
    Necessary if you're working on Windows.  Will work on POSIX OS's too
    if you're lazy, but mclapply() is pretty much guaranteed to be
    faster.  Often slower than serial implementations (which is rare
    for mclapply()).
3.  The detectCores() function determines the number of cores available
    to R, which can be very handy, if only for setting defaults.

These functions that facilitate parallelization, mclapply() and the
clusterApply functions, all behave kind of like lapply().  In fact,
mclapply() is kind of giving the game away by its name, as it is the
**m**ultiple **c**ore **lapply**.  If you're familiar with lapply(),
then you're already halfway there.

 

**Stop typing things no one wants to read and give me an example**

We're going to simulate 1,000,000 runs of the [Monty
Hall](https://en.wikipedia.org/wiki/Monty_Hall_problem) game (switching
every time) to see if we've been lied to all these years about the
probability of winning with this switching strategy really being 2/3. 
The serial (one core) implementation might look like this:

```R
system.time({
doors <- 1:3
runs <- 1e6
game.outputs <- numeric(runs)
for (run in 1:runs){
prize.door <- sample(doors, size=1)
choice <- sample(doors, size=1)

if (choice!=prize.door) game.outputs[run] <- 1 # Always switch
}
avg <- mean(game.outputs)
})[3]
```

When we do this, after 7.354 seconds we get a winning average of
0.666297, or approximately 0.666.  Clearly this result shows that Bayes'
Theorem is the work of Satan.  From Satan to voodoo, let's run the
simulation on multiple cores. Using the code below (Edit:  Correction
thanks to Owe Jessen)

```R
#########################################
# ---------------------------------------
# Functions
# ---------------------------------------
#########################################

# One simulation of the Monty Hall game
onerun <- function(.){ # Function of no arguments
doors <- 1:3
prize.door <- sample(doors, size=1)
choice <- sample(doors, size=1)

if (choice==prize.door) return(0) else return(1) # Always switch
}

# Many simulations of Monty Hall games
MontyHall <- function(runs, cores=detectCores()){
require(parallel)
# clusterApply() for Windows
if (Sys.info()[1] == "Windows"){
cl <- makeCluster(cores)
runtime <- system.time({
avg <- mean(unlist(clusterApply(cl=cl, x=1:runs, fun=onerun)))
})[3]
stopCluster(cl) # Don't forget to do this--I frequently do

# mclapply() for everybody else
} else {
runtime <- system.time({
avg <- mean(unlist(mclapply(X=1:runs, FUN=onerun, mc.cores=cores)))
})[3]
}
return(list(avg=avg, runtime=runtime))
}

#########################################
# ---------------------------------------
# Outputs
# ---------------------------------------
#########################################

run1 <- rbind(c(MontyHall(1e6, cores=1), "cores"=1))
run2 <- rbind(c(MontyHall(1e6, cores=4), "cores"=4))
run3 <- rbind(c(MontyHall(1e6, cores=8), "cores"=8))
rbind(run1, run2, run3)
```

we get

```R
avg      runtime cores
[1,] 0.666452 8.395   1
[2,] 0.665846 2.876   4
[3,] 0.666336 2.553   8
```

So for us, there was some pretty good speedup in going from 1 to 4 cores
(but a little slow down in going from an ordinary serial implementation
to mclapply() with mc.cores=1).  Notice that the one core time here is
roughly 3 times the 4 core time.  In an ideal world of perfect magical
rainbows, the 4 core time would be 4 times as fast as the 1 core time. 
The closer you can get to this kind of optimal scaling, the better, but
getting anything close to this ideal is rare.  The kind of scaling we
are seeing here is fairly typical and, frankly, not too bad.

Ok, so why the small jump from 4 to "8" cores?  Well, I don't have 8
cores; this computer only has 4.  So what's the deal?  You can set the
"number of cores" argument in these functions to a higher value than
what you actually have, and sometimes you can get some interesting
speedup.  Slightly more on this is discussed below in point 5.

Now, if you're on Windows, I'm not sure that this will be faster in
parallel than in serial.  The clusterApply family of functions have, in
my experience, very odd behavior on Linux, and I can only assume that
this odd behavior also exists on Windows.  What I'm trying to say is
that your mileage/kilometerage(?) may vary.

**UPDATE:**  It strikes me that because of the fat startup costs of the
clusterApply family, that this kind of scheme, while great for
mclapply() (my primary tool), is inappropriate.  So what you might do
instead is something like

```R

runs <- 1e6
manyruns <- function(n) mean(unlist(lapply(X=1:(runs/4),
FUN=onerun)))

library(parallel)
cores <- 4
cl <- makeCluster(cores)

# Send function to workers
tobeignored <- clusterEvalQ(cl, {
onerun <- function(.){ # Function of no arguments
doors <- 1:3
prize.door <- sample(doors, size=1)
choice <- sample(doors, size=1)
if (choice==prize.door) return(0) else return(1) # Always switch
}
; NULL
})

# Send runs to the workers
tobeignored <- clusterEvalQ(cl, {runs <- 1e6; NULL})
runtime <- system.time({
avg <- mean(unlist(clusterApply(cl=cl, x=rep(runs, 4),
fun=manyruns)))
})[3]
stopCluster(cl)

cbind(avg, runtime)
```

with output

```R
> cbind(avg, runtime)
avg runtime
elapsed 0.666466 3.644

```

So what we are doing here is chopping up the work so that, with 4 cores,
each one of the 4 cores is initialized to do 1/4 of the work all at
once.  It seems the title of this entry should be changed...whoopsies.

 

**Other thoughts**

1.  [RTFM](https://en.wikipedia.org/wiki/RTFM "Read The Friendly Manual"). 
    See 'library(help="parallel")' in R
2.  Check out the book [*Parallel R* by McCallum and Weston, O'Reilly
    publishing](http://www.amazon.com/Parallel-R-Q-Ethan-McCallum/dp/1449309925). 
    I've only thumbed it, but I liked what I saw, and it's cheap.
3.  Practice and experiment!
4.  The "parallel functions" all assume you have just one input.  If you
    have multiple inputs you want to feed in parallel (i.e., multiple
    things you want to vary), this problem can easily be remedied by
    dumping everything into strings with separater characters, then
    inside the function that gets fed to mclapply/clusterApply, unpack
    the single input into its multiple component inputs.
5.  When using mclapply(), mc.cores is the number of
    [forks](https://en.wikipedia.org/wiki/Fork_%28operating_system%29)
    you wish to spawn, not necessarily the exact number of physical
    cores you want to use (or even have).  The way cores get utilized in
    dealing with the forks is (thankfully) handled by the operating
    system.  However, as a result of this, if you experiment with
    different values of mc.cores, you may sometimes find non-trivial
    speedup by setting it to a value higher than detectCores(). 
    Speaking from practice (not theory), the returns quickly diminish
    when increasing the cores beyond what your computer physically has. 
    This may also work for the clusterApply family, but it might not;
    don't know as I tend not to use those functions.

To close, even though I (jokingly) discouraged it at the top of the
article, all comments are certainly welcome.
