---
layout: post
comments: true
title: Project Euler...in LaTeX?
date: 2012-04-23 18:50:28.000000000 -04:00
type: post
published: true
status: publish
categories:
- LaTeX
- Project Euler Solutions
- R
tags:
- LaTeX
- Project Euler
- R
author: wrathematics
---


I've been joking for a while now that I was going to start solving [project euler](http://projecteuler.net/) problems in [LaTeX](http://en.wikipedia.org/wiki/LaTeX).  Then today I finally did one.  So let's talk about solving Project Euler problem number 1 (the easy one) using only LaTeX.

The problem asks you to sum up all the positive integers below 1000 which are divisible by 3 or 5 (or both).  Doing this in R is easy.  You could efficiently do

```R
n <- 1:999
sum(n[which(n%%3==0 | n%%5==0)])
## [1] 233168
```

which according to R's system.time() runs in 0 seconds (less than a thousandth of a second).  You could also be loopy and do

```R
answer<-0
for (i in 1:999){
  if ((i%%3==0) || (i%%5)==0)
  answer<-answer+i
}
answer
## [1] 233168
```

which according to system.time() runs in 0.002 seconds.

Ok, yeah, R is good and all, but it doesn't *quite* have the nerd cred of LaTeX.

So in LaTeX, we don't have fancy pants things like floating point arithmetic.  The good lord Knuth gave us counters and so we shall use counters.  But because we're not completely (merely mostly) insane, we're going to use [the CTAN package fp,](http://www.ctan.org/tex-archive/macros/latex/contrib/fp/) which gives us some floating point-like behavior.  We will also use [the CTAN package forloop](http://www.ctan.org/tex-archive/macros/latex/contrib/forloop/), which, as the name suggests, is a simple (but very useful) LaTeX macro for doing for loops. 

So if you're already familiar with counters in LaTeX, then using fp can be very awkward at first.  If I have a counter n, I can't just use that with other fp things (at least not as far as I can tell).  You have to take the LaTeX counter n and transform it into a fp counter, say m, by doing

```latex
\newcounter{m}
\FPset{\m}{\arabic{n}}
```

Which only a mother could love.  Notice also that counters used as arguments inside of \\FPwhatever calls are preceded by a backslash, which sets off my alarm bells from years of LaTeX every time I look at it.

You may be asking "why do we even need anything like floating point for this problem?"  Well, the fp package, among other amazing things, has a little macro \\FPifint, which checks if a floating point counter is an integer or not, which is handy here.

Ok, so here's how you do it in LaTeX: 

```latex
\documentclass[a4paper,10pt]{article}
\usepackage[utf8x]{inputenc}
\usepackage{forloop} % for loops
\usepackage{fp} % floating point

\begin{document}
\section{Project Euler: Problem 1}

If we list all the natural numbers below 10 that are multiples of 3 or
5, we get 3, 5, 6 and 9. The sum of these multiples is 23.\\\

\noindent Find the sum of all the multiples of 3 or 5 below 1000.

\section{Solution}
\newcounter{sum}
\FPset{\sum}{0}

\newcounter{divthree}
\newcounter{divfive}

\newcounter{n}
\newcounter{fpn}

\forLoop[1]{1}{999}{n}{
% transform counter into FP counter
\FPset{\fpn}{\arabic{n}}
\FPdiv{\divthree}{\fpn}{3}
% test if divisible by 3, if so add to sum counter
\FPifint{\divthree} \FPadd{\sum}{\sum}{\fpn}
\else
\FPdiv{\divfive}{\fpn}{5}
\FPifint{\divfive}
\FPadd{\sum}{\sum}{\fpn}
\fi
}

The sum of all multiples of 3 or 5 below 1000 is \FPprint{\sum}.

\end{document}
```

Pretty cool, eh?  And in case anyone wants to see the output without compiling, [here is the pdf](http://librestats.com/wp-content/uploads/2012/04/pe1.pdf) of the output.  

```bash
time pdflatex p11.tex
## real	0m2.841s
## user	0m2.796s
## sys	0m0.016s
```

Ok, so it's not efficient, but it's pretty neat.
