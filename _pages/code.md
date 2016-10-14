---
layout: page 
title: Code
---


<link rel="stylesheet" href="{{site.baseurl | prepend:site.url}}/_pages/ui/css/custom.css" media="screen">

## R Packages


### Programming with Big Data in R (pbdR)
I am currently the co-lead developer of the pbdR ecosystem of packages.  These are a collection of utilities and services for leveraging R in HPC environments. For more information, see the main project website [http://r-pbd.org/](http://r-pbd.org/)


### System Hardware Info for R and Analytics (SHINRA)
SHINRA is a set of tools for benchmarkers working with R.  For more information about SHINRA, see [https://shinra-dev.github.io/](https://shinra-dev.github.io/)

### Analysis Packages

| Package | Description  | Download |
|---------|------------- | :------: |
| coop | Fast, efficient implementations of the "co-operations" (covariance, correlation, cosine similarity). | [ghbutton](http://github.com/wrathematics/coop) <br> [cranbutton](http://cran.r-project.org/package=coop){:style="padding:10"}
| pcapack | An experimental package for computing principal components and related statistical quantities in a high performance manner. | [ghbutton](http://github.com/wrathematics/pcapack)
| linmod | An experimental rewrite of R's lm.fit() and glm.fit() functions. Like R's implementation, it uses the "limited pivoting" strategy in a rank-revealing QR; unlike R, we use level 3 BLAS (and generally better memory management) when we can. | [ghbutton](http://github.com/wrathematics/linmod)
| yalda | "Yet Another LDA" package.  Wraps the serial portion of the Google plda program for use with R. | [ghbutton](http://github.com/wrathematics/yalda)

### Utilities

| Package | Description  | Download |
|---------|------------- | :------: |
| dequer | A package offering a custom data structure for R.  A deque is like a list, but with very cheap insertions (since R lists are contiguous arrays of pointers). | [ghbutton](http://github.com/wrathematics/dequer) <br> [cranbutton](http://cran.r-project.org/package=dequer){:style="padding:10"}
| lineSampler | Samples a file by line; quickly read a subsample of observations from a large flat text file (e.g., a csv).  Useful for downsampling; not suitable for resampling. | [ghbutton](http://github.com/wrathematics/lineSampler)
| RNACI | A collection of utilities that make dealing with R's native C interface more manageable.  Notably the package handles simplified SEXP allocation (with automatic gc counting), and the creation and management of lists and dataframes. For instance, by making use of C99's va_args, we can create arbitrary lists of named objects in just 2 simple function calls. | [ghbutton](http://github.com/wrathematics/RNACI)
| Rth | Multicore programming in R through the thrust template library. Compiles to an OpenMP, Intel Thread Buildingblocks, or CUDA backend. | [ghbutton](http://github.com/Rth-org/Rth)
| rexpokit | A set of bindings and utility functions for computing matrix exponentials via the Fortran 77 package EXPOKIT. | [ghbutton](http://github.com/wrathematics/rexpokit)

### Just for Fun

| Package | Description  | Download |
|---------|------------- | :------: |
| Rdym | A "did you mean?" tool for R to help catch spelling mistakes in an interactive R session. | [ghbutton](http://github.com/wrathematics/Rdym)
| Rfiglet | R bindings for figlet; creates ascii logos. | [ghbutton](http://github.com/wrathematics/Rfiglet)
| xkcdpw | A package for making portmanteau-style passwords, as in [this famous XKCD comic](https://xkcd.com/936/). Words are taken from scrapings of random Wikipedia pages. | [ghbutton](http://github.com/wrathematics/xkcdpw)
| tfca | Some methods for computing transfinite cardinal arithmetic. | [ghbutton](http://github.com/wrathematics/tfca)
| idgaf | All public GitHub commits containing the "F-word" in the commit message, from 3/11/2012 to 7/24/2014. (warning: profanity) | [ghbutton](http://github.com/wrathematics/idgaf)



<br><br>
## Libraries

| Package | Description  | Download |
|---------|------------- | :------: |
| libexpm | High-performance C library for computing the matrix exponential of a dense matrix. | [ghbutton](http://github.com/wrathematics/libexpm)
| meminfo | A fully cross-platform C library for accessing basic hardware information, such as total RAM, free RAM, total swap, etc. Additionally, can get cache sizes and cache line sizes. Supports Linux, Windows, Mac OS X, and FreeBSD. Used by the R package "memuse" from the SHINRA project. | [ghbutton](https://github.com/wrathematics/memuse/tree/master/src/meminfo)
| ngram | A C library for reading, processing, and "babbling" n-gram models. Used in the R package "ngram". | [ghbutton](https://github.com/wrathematics/ngram/tree/master/src/ngram)



<br><br>
## Webapps

### Large Projects

| Package | Description  | Download |
|---------|------------- | :------: |
| TAG | The Text Analytics Gateway (TAG) is an interactive webapp for performing simple analyses on unstructured text.  It includes tools for importing data, preprocessing, and modeling. | [ghbutton](https://github.com/XSEDEScienceGateways/TAG)
| gmhelper | A collection of utilities for game masters of fantasy-based role playing games, with a GUI and everything! | [ghbutton](http://github.com/wrathematics/gmhelper)


### Micro Projects

| Package | Description  | Download |
|---------|------------- | :------: |
| hackR | An interactive interface to the hackR package.  Now you can hack the gibson without needing to learn R! | [ghbutton](http://github.com/wrathematics/hackR) <br> [livebutton](https://wrathematics.shinyapps.io/hackR/){:style="padding:10"}
| ngram | An interactive interface to the ngram package.  Ever wanted to make your very own wacky sentences using markov chains?  Now you can! | [ghbutton](http://github.com/wrathematics/ngram) <br> [livebutton](https://wrathematics.shinyapps.io/ngram/){:style="padding:10"}
| RTop500 | A visual summary of the performance over time (by various metrics) of the top 500 supercomputers since 1993.  Written with R and shiny. Source is available in the RTop500 package. | [ghbutton](http://github.com/wrathematics/RTop500) <br> [livebutton](https://wrathematics.shinyapps.io/RTop500/){:style="padding:10"}
| Figlet as a Service | A demo of the Rfiglet package.  Written with R and shiny.  Source is available in the Rfiglet package. | [ghbutton](http://github.com/wrathematics/Rfiglet) <br> [livebutton](https://wrathematics.shinyapps.io/faas/){:style="padding:10"}


<script src="{{site.baseurl | prepend:site.url}}/_pages/ui/js/buttons.js"></script>
