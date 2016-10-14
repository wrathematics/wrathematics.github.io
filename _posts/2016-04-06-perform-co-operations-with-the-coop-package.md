---
layout: post
comments: true
title: Perform co-operations with the coop package
date: 2016-04-06 06:09:40.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Big Data
- HPC
- R
author: wrathematics
---


About
-----

The **coop** package does co-operations: covariance, correlation, and cosine, and it does them quickly. The package is available on [CRAN](https://cran.r-project.org/web/packages/coop/index.html) and [GitHub](https://github.com/wrathematics/coop), and has two vignettes:

-   [Introducing coop: Fast Covariance, Correlation, and Cosine Operations](https://cran.r-project.org/web/packages/coop/vignettes/coop.html)
-   [Algorithms and Benchmarks for the coop Package](https://cran.r-project.org/web/packages/coop/vignettes/algos.html)

Incidentally, the vignettes don't render correctly on CRAN's end for some reason; if any of you rmarkdown people have suggestions, I'm all ears.

The package is licensed under the permissive 2-clause BSD, and all the C code except for the custom NA handling stuff can easily be built as a standalone shared library if R's not your thing.

To get the most out of the package, you need a good BLAS library and a modern compiler that supports OpenMP, preferably version 4. Both of these issues have been written about endlessly, but if this is the first you've heard of them, see the package vignettes.

History
-------

The package was born out of needing to compute cosine similarities for a homework assigned to me last fall semester. I grabbed a package on the CRAN to perform the operation. I have a very good nose for when something is taking longer than it should, and was getting annoyed at how slow it was. So I wrote a version myself that was significantly faster for my purposes. Then I implemented a sparse version, because why not. At some point I wrote a custom `na.omit()` function for matrices which is \~3x faster than R's.

While implementing the cosine stuff, I realized it was basically the same calculation as covariance and (pearson) correlation, which I had already done in the [pcapack package](https://github.com/wrathematics/pcapack). So I tossed those in as well and put it all under one interface.

My enthusiasm for this problem also nicely explains why I haven't had a date in 4 years.

Benchmarks
----------

It's fast:

```R
library(coop)
library(rbenchmark)
cols <- c("test", "replications", "elapsed", "relative")
reps <- 25

m <- 20000
n <- 500
x <- matrix(rnorm(m*n), m, n)

benchmark(cov(x), covar(x), replications=reps, columns=cols)
## test replications elapsed relative
## 2 covar(x) 25 2.974 1.000
## 1 cov(x) 25 69.960 23.524
```

More benchmarks are available in the package [readme](https://github.com/wrathematics/coop/blob/master/README.md) and one of the package [vignettes](https://cran.r-project.org/web/packages/coop/vignettes/algos.html)

These benchmarks use the default "non-inplace" method, which for covariance and correlation will require a copy of the input data matrix. This is part of the usual time/space tradeoff, but if you're crunched for space and can wait, there's also an in-place method which uses considerably less extra storage at the cost of being way slower. Them's the breaks, kiddo. But it's still 3x or more faster than R's implementations on my hardware.

Future Directions
-----------------

The package is being actively maintained with new features added pretty regularly. I expect the package to mostly mature after a few more rounds of updates, namely:

-   Finish row-wise deletion for NA's with COO (sparse) storage.
-   Support `use="pairwise.complete.obs"` once I figure out what the hell that actually means.
-   Some C stuff you don't care about.

Not on the agenda: implementing other cov/cor methods. The [pcaPP](https://cran.r-project.org/web/packages/pcaPP/index.html) package purportedly does kendall's tau very efficiently. Spearman's rank also doesn't really interest me at the moment.

That's it! If you try the package and discover any issues, please let me know [on GitHub](https://github.com/wrathematics/coop/issues).
