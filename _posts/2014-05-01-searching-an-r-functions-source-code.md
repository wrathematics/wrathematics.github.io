---
layout: post
comments: true
title: Searching an R Function's Source Code
date: 2014-05-01 23:23:34.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- R
- regex
author: wrathematics
---


This is not nearly as interesting as it might first sound, but every function in R contains R code; this is true of core R code as well as extension packages. Sometimes the R code is just a very shallow wrapper around some compiled code, such as in `sum()` and `is.null()`. Other times, as in `lm.fit()`, there is a vast expanse of R code.

It's easy enough to print this source code; simply type in the function name without any parentheses or arguments. A nice way to search through that output from inside of R is to use `capture.output()` and then use standard regex utilities like `grep()`. Any standard printing to the R terminal (done via [Rprintf](http://cran.r-project.org/doc/manuals/R-exts.html#index-Rprintf)) will be captured like a `readLines()` call, either inside R itself or to a file, depending on function arguments. This is R's version of redirecting stdout with `>`, and here the usual caveats apply; i.e., errors and warnings are not captured:

```R
example <- capture.output(print("asdf"))
example
#[1] "[1] \\"asdf\\""

example <- capture.output(warning("asdf"))
#Warning message:
#In eval(expr, envir, enclos) : asdf
example
#character(0)

example <- capture.output(stop("asdf"))
#Error in eval(expr, envir, enclos) : asdf
example
#character(0)
```

But otherwise, it behaves exactly like you might expect:

```R
x <- matrix(1:30, nrow=10)
y <- capture.output(x)

y
# [1] " [,1] [,2] [,3]" " [1,] 1 11 21" " [2,] 2 12 22"
# [4] " [3,] 3 13 23" " [4,] 4 14 24" " [5,] 5 15 25"
# [7] " [6,] 6 16 26" " [7,] 7 17 27" " [8,] 8 18 28"
#[10] " [9,] 9 19 29" "[10,] 10 20 30"

cat(paste(y, "
"))
# [,1] [,2] [,3]
# [1,] 1 11 21
# [2,] 2 12 22
# [3,] 3 13 23
# [4,] 4 14 24
# [5,] 5 15 25
# [6,] 6 16 26
# [7,] 7 17 27
# [8,] 8 18 28
# [9,] 9 19 29
# [10,] 10 20 30
```

Clearly this utility makes our original problem completely trivial. For example, say we are interested in the `cov()` function:

```R
capture.output(cov)
#[1] "function (x, y = NULL, use = \\"everything\\", method =
c(\\"pearson\\", "
#[2] " \\"kendall\\", \\"spearman\\")) "
#[3] "{"
#[4] " na.method <- pmatch(use, c(\\"all.obs\\",
\\"complete.obs\\", \\"pairwise.complete.obs\\", "
# and so on...
```
Maybe we want to see all the `.Call()` lines:

```R
x <- capture.output(cov)
x[grep(x=x, pattern="[.]Call")]
#[1] " .Call(C_cov, x, y, na.method, method == \\"kendall\\")"
#[2] " .Call(C_cov, Rank(na.omit(x)), NULL, na.method, method == "
#[3] " .Call(C_cov, Rank(dropNA(x, nas)), Rank(dropNA(y, "
#[4] " .Call(C_cov, x, y, na.method, method == \\"kendall\\")"
```

And we can quickly turn this into a useful function using a bit more of
R's expressive sneakiness:
```R
stopper <- function(fun)
{
stop(paste("in match_src() : function fun='", fun, "' not found",
sep=""), call.=FALSE)
}

match_src <- function(fun, pattern, ignore.case=FALSE, perl=FALSE,
value=FALSE, fixed=FALSE, useBytes=FALSE, invert=FALSE,
remove.comments=TRUE)
{
### This is really too complicated, I apologize
err <- try(test <- is.character(fun), silent=TRUE)

if (inherits(x=err, what="try-error"))
stopper(fun=deparse(substitute(fun)))
else if (test)
{
err <- try(fun <- eval(as.symbol(fun)), silent=TRUE)

if (inherits(x=err, what="try-error"))
stopper(fun=fun)
}
err <- try(expr=src <- capture.output(fun), silent=TRUE)

if (inherits(x=err, what="try-error"))
stopper(fun=deparse(substitute(fun)))

# Remove comments
if (remove.comments) # test
{
src <- sub(src, pattern="#.*", replacement="")

num.empty <- which(src == "")
if (length(num.empty) > 0)
src <- src[-num.empty]

src <- sub(x=src, pattern="[ \\t]+\$", replacement="")
}

### Get matches and scrub
matches <- grep(x=src, pattern=pattern, ignore.case=ignore.case,
perl=perl, value=value, fixed=fixed, useBytes=useBytes, invert=invert)

src <- src[matches]

# remove leading and trailing whitespace
src <- sub(x=src, pattern="^[ \\t]+|[ \\t]+\$", replacement="")

return( src )
}
```

With example outputs:

```R
match_src(match_src, pattern="comment")
#[1] "function(fun, pattern, ignore.case=FALSE, perl=FALSE,
value=FALSE, fixed=FALSE, useBytes=FALSE, invert=FALSE,
remove.comments=TRUE)"
#[2] "if (remove.comments)"

match_src(match_src, pattern="comment", remove.comments=FALSE)
#[1] "function(fun, pattern, ignore.case=FALSE, perl=FALSE,
value=FALSE, fixed=FALSE, useBytes=FALSE, invert=FALSE,
remove.comments=TRUE)"
#[2] "# Remove comments"
#[3] "if (remove.comments) # test"

match_src("match_src", pattern="comment")
#[1] "function(fun, pattern, ignore.case=FALSE, perl=FALSE,
value=FALSE, fixed=FALSE, useBytes=FALSE, invert=FALSE,
remove.comments=TRUE)"
#[2] "if (remove.comments)"

match_src(match_srcs, pattern="comment")
#Error: in match_src() : function fun='match_srcs' not found
```

And here's everything in a [github
gist](https://gist.github.com/wrathematics/11378737) if that's more your
style.
