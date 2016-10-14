---
layout: post
comments: true
title: Rules for Naming Objects in R
date: 2013-12-16 20:00:05.000000000 -05:00
type: post
published: true
status: publish
categories:
- R
tags:
- Programming
- R
- R Quirks
author: wrathematics
---


Naming Rules in R
=================

How are objects allowed to be named in R? As it turns out, this is a very different question from how *should* objects be named. This isn't about style conventions, camelCase, dots.verus_underscores, or anything like that; this is about what is strictly possible.

I do a lot of outreach to HPC people who are starting to get an interest in R, often because their users are starting to ask for help with R. When I'm approaching these types of people, I usually say that naming rules are basically like C, but we can use dots like they use underscores.

This is a horrible lie.

From `?assign`:

> There are no restrictions on name: it can be a non-syntactic name (see make.names).

What does that mean? It means you can name an R object anything. ***ANYTHING***. You can even use unicode for object names (if you really hate yourself). But getting the parser to understand exactly what you mean isn't guaranteed if you do choose to embrace the full strength of R's naming "conventions" (is anarchy a convention?).  If you want to use wacky names, you have to be willing to give the interpreter some clues.  So for example, I can't have a syntactically valid (i.e., understandable by the R interpreter) name of 1 for an object:

```R
1 <- 2
```

R simply won't allow it.  If you use `make.names(names="1")`, you'll get back `"X1"` as the suggestion (something you've probably seen in variable names when using `read.table()`, for example).  But remember
that cryptic note about how non-syntactic names are allowed?  Nothing is stopping you from using `assign()`:

```R
assign(x="1", value=2)
```

You can prove that it works by checking your global environment with `ls()`.  You can even use quotation marks to achieve the same thing with `<-`.  But if you try to use your new, stupidly named variable, you might try just entering the character `1`.  That won't work; R returns the number 1, whereas we wisely chose to set 1 to 2.  If you try the characters `"1"` or `'1'`, then you'll be given the character 1 back.  The way to access our abomination is with the backtick.  Readers with a US layout keyboard can find this just underneath the Esc key.  Slightly more information their usage in the R helpfile `?Quotes` (case sensitive), but the basic idea is that it's used as a special flag to the parser.  So we can now convince ourselves that we really did indeed store the numeric value 2 in the object named 1:

```R
`1`
## [1] 2
> deparse(`1`)
## [1] "2"
```

We can also do fun things like:

```R
`1` <- 1+1
1 - `1`
## [1] -1
```

Remember when I said you could even use unicode (assuming your terminal supports it)? I wasn't lying:

```R
`☺` <- FALSE
`☹` <- TRUE
`ಠ_ಠ` <- "the look CS people give when they see these naming
rules"

ls()
## [1] "☹"   "☺"   "ಠ_ಠ"
```

All perfectly valid. Perhaps it's clear why many of us like to pretend this little gem about R doesn't exist (although in all seriousness, I actually find this really endearing).  Especially when you consider that plenty of computer science folks get grumpy when you tell them that we can use dots in our object names!

Quotes in R
===========

As mentioned above, there are three sets of quotes in R; single and double ticks, i.e. ' and ", generally serve the same purpose of creating character data (which the rest of the world calls strings).  There are some rules for precedence (use ' inside of ", not the other way around, unless you escape " with \\ ), but that's not why we're here.  Backticks are equally useful, but for different reasons. A good example is printing out the (R-level) source for binary operators.  Operators in R are functions, and functions have named arguments; so what are the names of the arguments of the addition function `+`?  If I were to just try entering the chracter + into the terminal, R would think I was evaluating it with one argument missing (which is allowed), and politely ask me for the other argument. Of course, regular quoting casts a string, so `"+"` is no good. The solution is the backtick:

```R
`+`
```

Evaluating this expression shows us that the argument names are `e1` and `e2`. This also allows us to demystify how the parser behaves with respect to operators in a (very) small way. Consider for example:

```R
`+`(1, 2)
```

Or

```R
`1` <- -1
`+`(1, `1`)
```

So should you go about naming your R variables `` `1 2 3 4 5 6` `` (yes, even spaces are allowed in this upside down world of madness). Probably not, but you can, and that's all that really matters.
