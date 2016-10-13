---
layout: post
title: Sorting in R as Inefficiently as Possible
date: 2012-01-12 23:08:27.000000000 -05:00
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


My [last post of
substance](http://librestats.com/2012/01/10/honing-your-r-skills-for-job-interviews/ "Honing Your R Skills for Job Interviews")
was all about improving your performance using R to answer programming
questions that might be asked during a job interview.  So let's say you
nailed the interview and got the job, but you desperately want to be
fired for grand incompetence.  Never fear, your pal at librestats once
again has your back.

**The sleep sort**

First, we'll tackle the sleep sort after an important message:

> **WARNING:**  the very first [sleep
> sort](http://rosettacode.org/wiki/Sorting_algorithms/Sleep_sort),
> which is linked to on that rosetta code link, was created at a place
> called 4chan which is **very** not safe for work---or particularly
> appropriate in any setting, as that site contains hate speech.  To be
> clear, [rosetta
> code](http://rosettacode.org/wiki/Welcome_to_Rosetta_Code) which I am
> linking to both here and above is fine--the source which they link to
> is not.

Now then.  I remember hearing about this almost a year ago and being
just blown away at how clever it is.  The algorithm basically relies on
sleeping, forking, and printing.  Sleeping is just what it sounds like;
you just tell everything to chill out for some specified amount of
time.  In R, this can be achieved with the Sys.sleep() function. 
Forking is a bit more complicated to understand.  I've discussed forking
somewhat in my [R
forkbomb](http://librestats.com/2011/09/14/r-fork-bomb/ "R Fork Bomb")explanation,
but here things are a little more straight forward (and less
malicious).  The basic idea is that we're going to use forking to tell
the program to "go on to the next thing you need to do" by spawning a
new R process (fork) to let the original one take care of whatever needs
to be done beforehand.  That's not a great explanation, but I think it
gets the basic idea across.  If you're not familiar with forking, the
[wikipedia
page](https://en.wikipedia.org/wiki/Fork_%28operating_system%29) does a
pretty good job of explaining the idea.  Finally, we use printing...with
print().

Ok, so how does the thing work?  I'll first explain by means of an
example.  Say you want to sleepsort the (ordered) numbers 3, 1, 2. 
Here's how you do it

1.  Sleep for 3 seconds.  At the end of those 3 seconds, print 3.
2.  While we're waiting for those 3 seconds, go ahead and spawn a new R
    process and move on to the next number.  That means we'll be (in the
    new R process) sleeping for 1 second (all while sleeping 3 in the
    original process), and at the end of that 1 seconds, we'll print 1.
3.  Just like above, we'll start a new R process and sleep for 2 seconds
    in that one, printing 2 when those 2 seconds are up.
4.  1 second is the least amount of time any of the R processes will be
    sleeping, so 1 gets printed first.  2 is the second least amount of
    time any of the R processes will be sleeping, so 2 gets printed
    next.  3 seconds takes the longest, so 3 gets printed last.

Make sense?  In general, the idea is to:

1.  Declare a function (and say we call it sleepn) which takes an
    appropriate numeric input n (not necessarily an integer, but
    non-negative--sorry, time travellers), sleeps for n seconds, then
    prints n.
2.  Given the vector to sort \$latex x=[x_1, x_2, \\dots, x_k]\$,
3.  For \$latex i=1, \\dots, k\$, sleepn(\$latex x_i\$) and fork

That's all there is to it.  So how about implementing that in R? 
Unfortunately, I'm not aware of any way to fork R on Windows platforms. 
However, it is possible with POSIX-like operating systems, such as Linux
and Mac OS X, using the function mcfork() (which uses the system's fork
function) from library(parallel).  Well, we'll technically be using
mcfork() via mclapply(), which was discussed somewhat in my [last
entry](http://librestats.com/2012/01/10/honing-your-r-skills-for-job-interviews/ "Honing Your R Skills for Job Interviews").

```r
# Sleepsort - POSIX only, i.e. no Windows, sorry :[
library(parallel)

sleepn <- function(n){
Sys.sleep(time=n)
return(print(n))
}

sleepsort <- function(x) invisible(mclapply(x, FUN=sleepn,
mc.cores=length(x)))
```

After I came up with my solution, I looked just about everywhere I
could, but I couldn't find anyone who had already done this in R.  So I
believe I am the first to write a fork bomb in R, and now a sleep sort
in R, which thrills me to no end.  Here's some sample output:

```r

> x <- sample(1:10, size=5, replace=FALSE)
> print(x)
[1] 3 5 1 8 2
> sleepsort(x)
[1] 1
[1] 2
[1] 3
[1] 5
[1] 8
>
```

Of course, it's worth pointing out that this method of sorting is, to be
charitable, not very practical.  For one, you can't sort vectors with
negative values in them.  Two, sorting the vector c(2000, 1) takes over
half an hour.  Three, even discounting the above, it doesn't always
work.  Observe:

```r

> x <- c(.03, .01, .02)
> sleepsort(x)
[1] 0.01
[1] 0.02
[1] 0.03
> x <- c(.003, .001, .002)
> sleepsort(x)
[1] 0.001
[1] 0.003
[1] 0.002
>
```

**The slow sort**

So say you've replaced R's sort() function with the sleep sorter.  Not a
bad move, really, but you feel like you could do worse.  Enter the [slow
sort](https://en.wikipedia.org/wiki/Bogosort).  This thing is
hilarious.  Let's go back to sorting our 3, 1, 2 example vector.  The
slow sort works thusly:

1.  Is the given vector in order?  If yes, stop and print the vector. 
    If not, go to 2.
2.  Randomly order the vector.  Go to 1.

Here was my first idea in writing a slow sort:

```r
# My first slowsort
slowsort <- function(x){
if ( !FALSE %in% (diff(x) >= 0)) return(x)
else slowsort(sample(x))
}
```

which involves recursively defining the function when it doesn't really
make sense to do so.  In fact, it's such a bad idea to do it this way,
you can even make R flip out.  Here's some sample output:

```r

> x <- c(5,3,25,1)
> slowsort(x)
[1]  1  3  5 25
> x <- 7:1
> slowsort(x)
Error: evaluation nested too deeply: infinite recursion /
options(expressions=)?

```

I'm not sure what it says about me that I somehow managed to make the
slow sort worse, but there you go.  When I realized what a dumb thing I
had done, I fixed it, then went out looking to see if anyone had done
this before.  In fact, someone had [already done a much better
job](http://rosettacode.org/wiki/Sorting_algorithms/Bogosort#R), and so
I present that person's code below

```r
# Better slowsort - not mine
bogosort <- function(x)
{
is.sorted <- function(x) all(diff(x) >= 0)
while(!is.sorted(x)) x <- sample(x)
x
}
```

with some timed sample output

```r

> x <- 10:1
> system.time(bogosort(x))[3]
elapsed
13.105
> system.time(sort(x))[3]
elapsed
0.001
>

```
