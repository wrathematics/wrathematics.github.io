---
layout: post
comments: true
title: Cache Rules Everything Around Me
date: 2015-02-12 08:15:12.000000000 -05:00
type: post
published: true
status: publish
categories:
- R
tags:
- Computer Science
- R
- Rcpp
author: wrathematics
---


Title with apologies to the Wu-Tang Clan.

In this post, we're going to be discussing:

-   Rcpp
-   R's C interface
-   The importance of CPU caches
-   Performance benchmarking

If none of these things is of interest you and you clicked anyway, please enjoy this picture of a cat:


![kitty]({{ site.baseurl }}/assets/kitty.jpg)

Background
----------

[Cache](https://en.wikipedia.org/wiki/CPU_cache) is like your computer's ram, only very small and 50-100 times faster to pull information from. Information in cache is easier to operate on than ram because, being in cache, it's literally, physically closer to the processor; I've always found this really interesting, but I guess if you think like a physicist instead of a mathematician then that's pretty obvious to you. Now, I've never claimed to be a hardware person, and plenty of people have already written about this kind of stuff in detail that makes me lose consciousness, so I'll spare you the details. The thing to remember is that caches are the key to good performance.

In preparation for my upcoming free webinar on [high performance R](http://www.nimbios.org/tutorials/TT_RforHPC), I created some basic Rcpp examples. Naturally, I decided on the "numerical hello world", aka that dumb monte carlo scheme to estimate pi. I thought it would be interesting to compare the Rcpp solution to one using R's regular C interface, and discuss the performance/syntax tradeoff. The general advice I give is that Rcpp will have very slight overhead, so be careful if you're calling something billions of times and that extra half a second matters to you.

So was that the case? And how does all of this relate to CPU caches? Read on, impatient friend!

A Tale of Two Functions
-----------------------

So here's how you might do this with Rcpp:

```CPP
#include <Rcpp.h>

// [[Rcpp::export]]
double mcsim_rcpp(const int n){
  int i, r = 0;
  double u, v;
  Rcpp::RNGScope scope;

  for (i=0; i<n; i++){
    u = R::runif(0, 1);
    v = R::runif(0, 1);

    if (u*u + v*v <= 1)
    r++;
  }

  return (double) 4.*r/n;
}
```

And here's how you might do it with R's C interface:

```c
#include <R.h>
#include <Rinternals.h>

// [[Rcpp::export]]
SEXP mcsim_c(SEXP n_){
  SEXP ret;
  int i, r = 0;
  const int n = INTEGER(n_)[0];
  double u, v;

  GetRNGstate();

  for (i=0; i<n; i++){
    u = unif_rand();
    v = unif_rand();

    if (u*u + v*v <= 1)
    r++;
  }

  PutRNGstate();

  PROTECT(ret = allocVector(REALSXP, 1));
  REAL(ret)[0] = (double) 4.*r/n;
  UNPROTECT(1);
  return ret;
}
```

Pretty similar, really. Both have weird boilerplate for handling the RNG. Beyond that, the Rcpp version looks like simple C++, rather than the nightmare monstrosity that is R's C interface. You could also use the Rcpp sugar version of the random number generator, but it uses much more memory (it's the same as R's `runif()` function, basically).

An easy way to run this is to dump the C/C++ source into R strings, say named `Rcpp_code` and `C_code`, and to build them like so:

```R
library(Rcpp)

sourceCpp(code=Rcpp_code)
sourceCpp(code=C_code)
```

[This GitHub gist](https://gist.github.com/wrathematics/ab7dd9e5a3b139c84418) does this for your convenience.

Now, let's benchmark them. Again, I expect the Rcpp solution to be pretty close in terms of runtime performance:

```R
library(rbenchmark)

n <- 1e6L
benchmark(mcsim_c(n), mcsim_rcpp(n))
## test replications elapsed relative user.self sys.self user.child
## 1 mcsim_c(n) 100 1.609 1.000 1.598 0.004 0
## 2 mcsim_rcpp(n) 100 3.099 1.926 3.084 0.001 0
```

Erm --- that's not that close. That's actually pretty bad. What's going on here?

The Importance of Caches
------------------------

So far, the only thing that I know is that the Rcpp version is unacceptably slower; but I have no idea at all **why** it's slower. To try to answer this question, we'll be turning to [pbdPAPI](https://github.com/wrathematics/pbdPAPI), which I [have written about in the past](http://librestats.com/2014/07/22/advanced-r-profiling-with-pbdpapi/). The quick summary is that pbdPAPI was a 2014 Google Summer of Code project that offers very advanced profiling capabilities to R. It allows you to measure things like --- you guessed it --- cache misses and CPU instructions.

So let's see how the two compare at the instruction level:

```R
library(pbdPAPI)

### Total instructions executed
system.event(mcsim_c(n), events="PAPI_TOT_INS")
## Instructions Completed: 131035426
system.event(mcsim_rcpp(n), events="PAPI_TOT_INS")
## Instructions Completed: 227028352

### L1 Instruction Cache Misses
system.event(mcsim_c(n), events="PAPI_L1_ICM")
## Level 1 Instruction Cache Misses: 604
system.event(mcsim_rcpp(n), events="PAPI_L1_ICM")
## Level 1 Instruction Cache Misses: 873
```

So the Rcpp version is executing almost twice the number of instructions as the C version. This generates more instruction cache misses, which degrades performance. But what about everyone's favorite cache, the data cache? Not really relevant here:

```R
system.cache(mcsim_c(n))
## Level 1 Cache Misses: 1358
## Level 2 Cache Misses: 720
## Level 3 Cache Misses: 400

system.cache(mcsim_rcpp(n))
## Level 1 Cache Misses: 1316
## Level 2 Cache Misses: 747
## Level 3 Cache Misses: 248
```

Notice that there are really only a few differences between the two implementations, and that the random number generation particularly stands out between them. So what if we just change those 2 lines of the Rcpp version to use `unif_rand()` instead of `R::runif()`?

```R
library(rbenchmark)

n <- 1e6L
benchmark(mcsim_c(n), mcsim_rcpp(n))
## test replications elapsed relative user.self sys.self user.child
## 1 mcsim_c(n) 100 1.608 1.000 1.599 0.002 0
## 2 mcsim_rcpp(n) 100 1.627 1.012 1.596 0.024 0

system.event(mcsim_c(n), events="PAPI_TOT_INS")
## Instructions Completed: 131035315
system.event(mcsim_rcpp(n), events="PAPI_TOT_INS")
## Instructions Completed: 131030768
```

Ahh, much better.

Conclusions
-----------

The R community is starting to take a greater interest in improving performance; I think this is great! But I do wonder about the people I see shaving off microseconds on kilobytes of data and proclaiming absolute victory. First of all, if microseconds matter to you, you need to stop using R immediately. The language you are looking for is called C, and it's been waiting for you for the last 40 years. Second, and this is assuming the software is fairly general (i.e., meant to handle a variety of inputs well), then you really ought to make sure that the performance doesn't swiftly degrade once data no longer resides in cache (data or instruction). If you were to re-run the above examples with a much smaller value of `n`, you would find that the two solutions look comparable in terms of runtime performance and cache misses. Even though as we have seen, as you scale up, a clear difference between them emerges.

"But how big are my caches?", I hear you ask. The short answer is: tiny. The better answer is, find out for yourself with [the memuse package](https://github.com/wrathematics/memuse).

Install via `install.packages("memuse")`

And run via:

```R
library(memuse)

Sys.cachesize()
## \$L1I
## 32.000 KiB
##
## \$L1D
## 32.000 KiB
##
## \$L2
## 256.000 KiB
##
## \$L3
## 6.000 MiB
```

memuse is a surprisingly useful little package, I find. Then again, I wrote it so take that with a grain of salt. But I plan to describe its features more in-depth in a later post.

Happy hacking.
