---
layout: post
title: pbdR Updates - Distributed lm.fit() and More
date: 2012-12-03 18:05:15.000000000 -05:00
type: post
published: true
status: publish
categories:
- R
tags:
- Parallel R
- pbdR
- R
author: wrathematics
---


Over the weekend, we updated all of the [pbdR](http://r-pbd.org/) packages currently available on the CRAN.  The updates include tons of internal housecleaning as well as many new features.

Notably, [pbdBASE_0.1-1](http://cran.r-project.org/web/packages/pbdBASE/) and [pbdDMAT_0.1-1](http://cran.r-project.org/web/packages/pbdDMAT/index.html) were released, which contain lm.fit() methods.  This function in particular has been available at [my github](https://github.com/wrathematics) for over a month, but didn't make its way to the CRAN until recently because of some annoying issues with S4 methods and R CMD check (don't get me started).  But just a friendly reminder that features, tweaks, and bugfixes will make their way into our github repos much faster than they will make their way into the CRAN.

I'm going to have a LOT to say about lm.fit() in my next entry --- more than you probably ever thought possible.  For now I'll just say that our implementation is passing all of my tests, and early benchmarking suggests that it's pretty fast if you throw a large enough problem at it.

If you have questions about any of our packages, feel free to ask us at [our google group](https://groups.google.com/forum/?fromgroups#!forum/rbigdataprogramming).

 

**Coming Soon**

What's coming soon ("soon") for pbdR?  We've been working on a very thorough collection of package demos.  That will be on the CRAN as soon as I can convince myself to write more documentation (don't get me started).

We have also been hard at work creating some hooks into parallel readers.  Very soon, you will be able to use parallel  [netCDF-4/HDF5](https://en.wikipedia.org/wiki/NetCDF) to read/write your data in a distributed way and easily use it inside the existing pbdR toolchain.  We are also implementing a set of wrappers for the extremely powerful I/O middleware [ADIOS](http://www.olcf.ornl.gov/center-projects/adios/).  ADIOS is used on something like 40% of projects on the [Jaguar supercomputer](https://en.wikipedia.org/wiki/Jaguar_%28supercomputer%29), which was recently upgraded to one again become the fastest supercomputer in the world (renamed to [Titan](https://en.wikipedia.org/wiki/Titan_%28supercomputer%29)).  This is how some of the biggest projects in the world are handling their simulation data, and soon it is coming to R.

In other news, our team leader [George Ostrouchov](http://www.csm.ornl.gov/~ost/) is going to be [giving a talk at the 2013 SIAM conference](http://meetings.siam.org/sess/dsp_talk.cfm?p=56975) at a mini-symposium on [Fast Numerical Computing with High-level Languages](http://meetings.siam.org/sess/dsp_programsess.cfm?sessioncode=15480).  Perhaps most exciting to me is that out of the 8 talks currently scheduled for the two sessions, 3 of them are specifically about developments in R.

 

**Rcpp and pbdR Followup**

In [my last entry](http://librestats.com/2012/10/16/r-at-12000-cores/ "R at 12,000 Cores") I made some comments about [Rcpp](http://cran.r-project.org/web/packages/Rcpp/index.html).  First let me clarify that the package loading issue isn't about the 20mb total install size --- that was a mistake that I'm not even sure how I made.  The issue is with the Rcpp.so library which is on the order of 4mb.  That may not sound like much at all, but a 4mb dynamic library loaded up on thousands of processors costs more than you might expect, and not necessarily for the reasons you might expect either.  We have recently been talking with the people who have been using Python on the order of 65,000 cores, and they have been incredibly helpful in giving us some interesting insights into how we might solve this dynamic library loadup problem, to a degree anyway. But even if we do, one could argue that with all the bloat of R and pbdR packages we have to carry around, should we use Rcpp which is, strictly speaking, not necessary?  I don't yet have enough evidence to sway me to or from this opinion.

For the moment we will continue to use Rcpp in pbdR.  One thing I must point out is that cutting Rcpp out of our packages is not as simple a thing as removing the letters "Rcpp" from our dependencies section of the package.  Rcpp is an incredibly powerful tool that provides a lot of abstraction using C++ template voodoo to give developers the ability to write something that looks very much like R but compiles to be fast as hell.  If we "drop" Rcpp, so too do we drop that nice abstraction layer and return to the abyss that is R's official and very barebones C interface.  Boy, I sure do love counting the number of objects I am hiding from the garbage collector, and remember if you use malloc that you call free, but if you use R_alloc then you don't, oh by the way your code just segfaulted.  Moving away from Rcpp would cost us extra development time, something that really shouldn't be minimized in all this, and perhaps was unfairly so in the previous post. 

Now I'd like to be perfectly clear on this.  I'm not talking about computational overhead.  To some people, it is somewhat in vogue to talk about what a glorious computational burdern Rcpp, or C++ in general, have over C.  If that's your opinion, stop using R right now and go write your own lm() in C.  And stay there.  If you don't, don't expect me to take your opinion on this seriously ever.  What I'm talking about is a weird I/O thing which Rcpp *may or may not* be non-trivially contributing to at a very large processor scale. 

Now as Dirk correctly points out, if there is a cost in there we are worried about, we should measure it.  I'm working on that.  But let me be perfectly clear.  Rcpp is *awesome*.  It's almost like writing R code, but with up to 100x the speed.  Seriously.  For rapid compiled code prototyping, you can't get much better than Rcpp short of a fully functional llvm project for R ([which is being worked on](http://www.omegahat.org/Rllvm/), though the project is in early stages and may never reach the full functionality of R). 

That's a very long way of saying no new news on the long loadup time front.  But we will eventually tackle this problem (with much help from the Python community, and hopefully others).

 

**Concluding Thoughts**

That sure was a lot of words you didn't just read.  So what's the short version of the story?  At the end of the day, we are determined to make R a serious competitor in high performance computing.  Scalable, exploratory analytics are coming to a supercomputer near you, powered by R.
