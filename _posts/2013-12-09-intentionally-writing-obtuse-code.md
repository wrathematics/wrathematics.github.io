---
layout: post
comments: true
title: Intentionally Writing Obtuse Code
date: 2013-12-09 16:15:31.000000000 -05:00
type: post
published: true
status: publish
categories:
- R
tags:
- Programming
- R
- Rcpp
author: wrathematics
---


Sometimes intentionally writing bad code can be a lot of fun. Now here, when I say "bad", I mean something that's functional but completely incoherent to anything but the machine. There are even [competitions](http://ioccc.org/) for this kind of thing, but I only consider myself a dabbler in this dark art. Thankfully, it's often pretty easy to make obtuse code in R.

Given that I have a weird admiration for bad code (in the sense outlined above), it's probably no surprise that I am also a fan of communities full of smart people who pretend to be stupid. One of my favorite such is the [shittyprogramming subreddit](http://www.reddit.com/r/shittyprogramming), which simply has to be seen to fully appreciate. One post there I read fairly recently which struck me was [this one](http://www.reddit.com/r/shittyprogramming/comments/1pnuqy/help_i_cant_get_this_program_to_work/cd46q6n). The challenge is:

```
Using no more than 3 loops, create a program that
generates the following pattern of 1

1111111111 111111111 11111111 1111111 111111 11111 1111 111 11 1
1111111111 111111111 11111111 1111111 111111 11111 1111 111 11 1
```

Now, if you tend to come more from the analysis side of things in R rather than programming, you might not fully appreciate how ridiculous this is. But it's a pretty good parody of elementary programming examples and the people who beg for solutions to them (generally lazy students).

So what are some bad solutions to this problem? Obviously ones which violate the spirit but not the directions qualify, such as

```R
for (i in 1:2)
print("1111111111 111111111 11111111 1111111 111111 11111 1111 111 111")
```

or perhaps better

```R
cat("1111111111 111111111 11111111 1111111 111111 11111 1111 111 111 1111111111 111111111 11111111 1111111 111111 11111 1111 111 111")
```

As for something a little more obtuse in a less meta way, you might chain a bunch of functions together like so:

```R
cat(paste(paste(rep(paste(sapply(10:1, function(n) paste(rep(1, n), collapse="")), collapse=" "), 2), collapse=" "), ""))
```

But if you really want to make incomprehensible code, nothing beats the wealth of options available in C or C++. An inappropriate stream of [goto's](https://en.wikipedia.org/wiki/Goto) and needless [bit shifting](https://en.wikipedia.org/wiki/Bitwise_operation) beats just about anything. Sadly, R has neither goto's nor bit shifting, so we will have to drop to compiled code for the purpose of demonstration. For the sake of simplicity and reproducibility, I'll be wrapping things in [Rcpp](http://cran.r-project.org/web/packages/Rcpp/index.html). Never used Rcpp before? Just do the usual install.packages and tada, you have compiled code for R at your fingertips. For further simplicity, I will actually be using the [inline package](http://cran.r-project.org/web/packages/inline/index.html), which again you can just install as usual. This package allows you to just dump C++ code straight into your R script (as raw text) and compile it with a simple R function. I really don't recommend doing this for production codes (I bring this up because I've seen it, sadly), but it can be a handy way to do quick testing or to distribute examples without the complexity of an R package.

If you were to try to do this in C++ following the spirit and the letter of the directions, and assuming you're a somewhat reasonable person, you might do something like this:

```R
library(inline)

print_ones <- function(.)
{
  print_ones_cpp <- cxxfunction(
  signature(),
  body='

  int i, j, rep;

  for (rep=1; rep<3; rep++)
  {
    for (i=10; i>0; i--)
    {
    for (j=0; j<i; j++)
      std::cout << "1";

      std::cout << " ";
    }

    std::cout << std::endl;
  }

  return wrap((int) 0);

  ',plugin="Rcpp"
  )

  print_ones_cpp()
  invisible(NULL)
}

print_ones()
```

But that's boring; you probably even understand how it works, even if you don't know C/C++. And worse, it uses 3 loops. A much better solution is:

```R
library(inline)

print_ones <- function(.)
{
  print_ones_cpp <- cxxfunction(
  signature(),
  body='

  #define J 0
  #define java_lang_System_out_println(x) std::cout << (x) // code now enterprise ready
  int i = 0, j, num;

  goto A;

  AA:
  java_lang_System_out_println(\\"1\\");
  j = -\~j;

  goto h;

  c:
  return wrap(0);

  A:
  if (i & 1<<1)
  goto c;
  goto L;

  a:
  j = 1>>1;
  goto E;

  h:
  if (j < num)
  goto AA;
  goto d;

  E:
  if (num == J)
  goto C;
  goto h;

  L:
  num = (1<<1<<1<<1) + (1<<1);
  goto a;

  d:
  java_lang_System_out_println(\\" \\");
  num--;

  goto a;

  C:
  java_lang_System_out_println(std::endl);
  goto b;

  b:
  i++;
  goto A;

  ',plugin="Rcpp"
  )

  print_ones_cpp()
  invisible(NULL)
}

print_ones()
```

Much better! And we didn't even have to use any of those pesky loops which get in the way of the superior goto! For more goto madness, see my post on [Fizzbuzz in Fortran](http://librestats.com/2013/04/26/the-fizzbuzz-that-fortran-deserves/).

For anyone wondering why it takes so long to run, it's because compilation of anything in C++ always takes ages, and I stuffed the compile statement inside the body of the calling R function. This too is bad design, but chosen for compactness rather than amusement.
