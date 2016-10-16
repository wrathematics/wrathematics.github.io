---
layout: post
comments: true
title: 'Project Euler in R:  Problem 6'
date: 2011-08-18 14:28:57.000000000 -04:00
type: post
published: true
status: publish
categories:
- Project Euler Solutions
tags:
- Math Mistakes
- Project Euler
- R
author: wrathematics
---


**Problem:** Find the difference between the sum of the squares of the
first one hundred natural numbers and the square of the sum.

**Commentary:** I taught a variety of freshman math courses at my
university for roughly 5 years. As such, this problem is very near and
dear to my heart.****

I can't tell you how many kids show up at university thinking they're
hot shits because they took Calc 1 in high school, but don't know that

$$ a^2+b^2 \neq (a+b)^2 $$

This is just one of many adorable things freshmen tend to belive, 
along with all their ridiculous political beliefs and thinking they'll
somehow change the world in any appreciable way. Adorable.

Actually, students thinking that the sum of the squares is equal to the
square of the sum is so common, that it has its own name. We call it the
"freshman dream". I've also heard it called "Baby's Binomial Theorem",
which is way funnier, but much less commonly heard. And since I guess I
have to mention it, there are number-like structures out there where the
freshman dream is true (fields of characteristic 2 for my algebros), but
the real numbers certainly aren't one of them.

What's especially funny about this misunderstanding is that it's
literally almost never true (for real numbers). Pick your favorite two
numbers--they don't even have to be integers. They can even be the same
number. Unless one (or both) of them is zero, then tada, the sum of the
squares isn't equal to the square of the sum.

So what other crazy (mathematical) things do university students tend to
come up with in freshman math class? Just on the order of basic
arithmetic, it's almost shocking how little mastery they have over the
subject. And we're not talking about "complicated" things like the
limit, integration, or any other worthless calculus crap. This is
arithmetic. *Our university students don't understand arithmetic*.

Just off the top of my head, these are some of the most common
misunderstandings, not counting that mentioned above. Keep in mind,
everything that follows is *not* true, and what's more, they're not true
for practically any numbers you throw at them (try it yourself!)

$$ \sqrt{a^2+b^2}=a+b $$

$$ -(a+b)=-a+b $$

$$ \frac{a}{c}+\frac{b}{d} = \frac{a+b}{c+d} $$

$$ \frac{a+b}{a}=b $$

$$ \frac{a}{a+b}=\frac{1}{b} $$

And that's not even getting into logarithms or trigonometry, which
*none* of them understand.

This has a lot to do with why I gave up teaching for the cushy office
life. I haven't looked back since.

**R Code:**

```R
ElapsedTime<-system.time({
##########################
answer <- abs(sum((1:100)^2)-sum((1:100))^2)
##########################
})[3]
ElapsedMins<-floor(ElapsedTime/60)
ElapsedSecs<-(ElapsedTime-ElapsedMins*60)
cat(sprintf("
The answer is: %d
Total elapsed time: %d minutes and
%f seconds
", answer, ElapsedMins, ElapsedSecs))
```

**Output:**
The answer is: 25164150
Total elapsed time: 0 minutes and 0.000000 seconds
