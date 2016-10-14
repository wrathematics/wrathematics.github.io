---
layout: post
comments: true
title: A Math Degree in the Kitchen
date: 2011-08-17 13:02:20.000000000 -04:00
type: post
published: true
status: publish
categories:
- Math
tags:
- Math
- Number Theory
author: wrathematics
---


So today I was making some rice, and I decided based on calorie load
that I wanted more than 1/3 cup of rice, but less than 1/2. I decided
that 5/12 cup was acceptable, but my only tools were a 1/4 cup scoop and
a 1/3 cup scoop.

I didn't have to think very hard about this; I instantly knew it was
possible to get 5/12 cup of rice with these tools, because 4 and 3 are
relatively prime--i.e., they share no common factors. More on this in a
minute, but first, how to do it.

It's a very uncomplicated idea, and it should look very similar to the
Diehard 3 water puzzle. In the film, John McClain has a 3 liter jug and
a 5 liter jug, and wants to get exactly 4 liters of water. My rice
puzzle is basically the same game. To get my 5/12 cup of rice, I fill
the 1/3 cup scoop and pour that rice into my rice cooker. Then I again
fill the 1/3 scoop and pour that (without spilling) into the 1/4 scoop.
How much remains in the 1/3 scoop? Well, I had 4/12 cup of rice in it,
and I took out 3/12 cup of rice. So only 1 remains in the 1/3 cup scoop.
Add the 1/12 to the rice cooker, and since 1/3+1/12=5/12, we're done.
And although that's how I did it, I actually didn't even need to get the
rice cooker involved. I can form 5/12 cups inside the scoops without
having to use another vessel (though the thing holding all my rice is
allowed). I could have filled the 1/3 cup scoop, poured that into the
1/4 cup scoop, emptied the 1/4 cup scoop, poured the 1/12 cup in the 1/3
cup scoop into the 1/4 cup scoop, then filled the 1/3 cup scoop. Tada!

I warned you that it was very uncomplicated; the above is really not
very interesting on any level. What *is* interesting is *why* this
works, and how I knew so quickly that it must be possible to do it. If
you don't know why, then all that stuff I just wrote might seem like a
cute curiosity, when really there is a very basic underlying principle
involved. Instead of needing to ask "I wonder if it's possible to get
1/6 cups of rice with those tools", I can instantly say that the answer
is "yes". I didn't have to think about it at all. Here's how it works.

Instead of thinking of the scoops as 1/4 and 1/3 cup, I'll do you a
favor and eliminate the fractions for you. Let's think of them as 3 and
4 serving scoops (out of 12), respectively. Believe it or not, we're
almost done. As it turns out, if the greatest common divisor (written
\$latex gcd\$) of these two values (in this case 3 and 4 from 1/4 cup
and 1/3 cup scoops, respectively) is 1, then it's possible to get any of
1/12, 2/12, 3/12, 4/12, 5/12, 6/12, or 7/12 cups of rice (maxing out at
3+4=7, because that's the maximum amount of stuff our two scoops can
hold). Said another way, I can get 1, 2, 3, 4, 5, 6, or 7 servings (out
of 12) in this fashion. Why? Because if \$latex gcd(3,4)=1\$ (and thank
goodness that's the case), then there exist integers \$latex x\$ and
\$latex y\$ satisfying

\$latex 3x+4y=1\$

But that isn't what I wanted! I wanted something like \$latex 3a+4b=5\$.
But this is easy. Multiply the above equation on both sides by 5 and we
get

\$latex 5(3x+4y)=3(5x)+4(5y)=5\$

So just call \$latex 5x=a\$ and \$latex 5y=b\$. So it must be possible.

And people say that pure math has no practical application.
