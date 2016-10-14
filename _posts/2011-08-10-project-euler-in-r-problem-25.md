---
layout: post
comments: true
title: 'Project Euler in R: Problem 25'
date: 2011-08-10 23:22:23.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- fibonacci numbers
- phi
- Project Euler
- R
author: wrathematics
---


**Problem 25:** What is the first term in the Fibonacci sequence to
contain 1000 digits?

**Commentary:** Well, I certainly hope you paid attention to all the
boring crap in the solution to [Problem
2](http://librestats.wordpress.com/2011/08/10/project-euler-in-r-problem-2/ "Project Euler in R:  Problem 2"),
because you're going to need it to understand my solution for Problem
25.

First, I'll describe my first attempted solution, which was a
"computery" approach. My original plan was to use the closed form
(discussed in the link above) to the Fibonacci Numbers, passing off all
the "heavy lifting" to [GNU
bc](https://secure.wikimedia.org/wikipedia/en/wiki/Bc_programming_language "bc programming language").
This "works", but is UNBELIEVABLY slow (I think I let it run for about
15 minutes before I decided to try to math my way out of things). This
problem is a good reminder (though we'll definitely see others) of the
inarguable fact that mathematicians are still kings of earth--or at
least that the Project Euler people like to occasionally throw a bone to
math-types instead of letting the computer science nerds have all the
fun.

Ok, so, remember that weird "continued fraction" expansion of \$latex
\\phi\$ that I gave in the solution to Problem 2? If you stare at it for
a few seconds, then it should be obvious that

\$latex \\phi = 1+\\displaystyle\\frac{1}{\\phi}\$

and hence

\$latex 1-\\phi = \\displaystyle\\frac{1}{\\phi}\$

While we're here, it's worth pointing out that if you *define* \$latex
\\phi\$ in terms of that continued fraction expansion, then you can
deduce from that definition the numeric value of \$latex \\phi\$ , since
from the first equation above, if we multiply both sides by \$latex
\\phi\$, then rearrange things and get

\$latex \\phi^2-\\phi-1=0\$

Using the good old quadratic formula gives two solutions (or in other
words, two possibilities for \$latex \\phi\$), namely \$latex
\\displaystyle\\frac{1\\pm\\sqrt{5}}{2}\$. One of these two
possibilities is positive and the other negative. From there it isn't
hard to see which is which.

Ok, so back to Project Euler. With the above observation regarding
\$latex 1-\\phi\$, we can rewrite the closed form expression of the
Fibonacci Numbers (using the Project Euler convention that \$latex
F_1=F_2=1\$) as

\$latex F_n =
\\displaystyle\\frac{\\phi^n-\\left(\\frac{1}{\\phi}\\right)^n}{\\sqrt{5}}\$

Then for sufficiently large \$latex n\$ (and thinking about the problem
at hand for 3 seconds should convince you that the \$latex n\$ we're
after should do the trick), we have

\$latex F_n\\approx\\displaystyle\\frac{\\phi^n}{\\sqrt{5}}\$**

since of course \$latex
\\displaystyle\\left(\\frac{1}{\\phi}\\right)^n\$ will be *quite*
small. It follows that we need only find the smallest natural number
\$latex n\$ satisfying

\$latex F_n = \\displaystyle\\frac{\\phi^n}{\\sqrt{5}}>10^{999}\$

And since \$latex \\log\$ is an increasing function, this is equivalent
to needing to find the smallest n satisfying

\$latex \\log_{10}(F_n)>999\$

The problem is now trivial. Note that from the above observation
regarding \$latex \\displaystyle\\left(\\frac{1}{\\phi}\\right)^n\$ and
from basic properties of logarithms:

\$latex \\log_{10}(F_n) =
n\\log_{10}(\\phi)-\\frac{1}{2}\\log_{10}(5)\$

Whence, we wish to find the smallest natural number \$latex n\$
satisfying

\$latex
n>\\displaystyle\\frac{999+\\frac{1}{2}\\log_{10}(5)}{\\log_{10}\\left(\\phi\\right)}\\approx
4781.859\$

It follows that \$latex n=4782\$.

Who says a masters in math is useless?

**R Code:**

```R
ElapsedTime <- system.time({
##########################
phi<-(1+sqrt(5))/2
answer<-ceiling((999+1/2*log(5, 10))/log(phi, 10))
##########################
})[3]
ElapsedMins <- floor(ElapsedTime/60)
ElapsedSecs <- (ElapsedTime-ElapsedMins*60)
cat(sprintf("
The answer is: %d
Total elapsed time: %d minutes and
%f seconds
", answer, ElapsedMins, ElapsedSecs))
```

**
Output:
**The answer is: 4782
Total elapsed time: 0 minutes and 0.000000 seconds**
**
