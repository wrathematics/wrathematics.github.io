---
layout: post
title: Password Input with getPass
date: 2016-04-26 08:36:21.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- R
author: wrathematics
---


As of this morning, the [getPass package](https://cran.r-project.org/package=getPass) version 0.1-1 is available on CRAN. The package offers a portable way to read user input without echoing the text, for the purposes of reading passwords. Some screenshots from various platforms are given below. 

![getPass]({{ site.baseurl }}/assets/getPass.png)

Implementation details are described in the [package vignette](https://cran.r-project.org/web/packages/getPass/vignettes/getPass.html). The short version is, if you use...

-   **RStudio**, input is handled by the [rstudioapi package](https://cran.r-project.org/package=rstudioapi)
-   **command line** (any OS), a custom reader written in C is used
-   **RGui** (Windows), then a tcltk reader is used.
-   **R.app** (Mac), then we attempt to use tcltk if it is available.

If none of these options is available for your platform/interface, then a backup version without masking can be used, via R's `readline()`. I believe this supports just about everything, except emacs+ess, which I
don't think *can* be supported (if you have any ideas, please let me know). If you discover any problems, please [file an issue](https://github.com/wrathematics/getPass/issues).
