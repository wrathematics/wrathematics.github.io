---
layout: post
title: 'One of My Favorite R Oddities:  dump()'
date: 2015-01-26 05:11:49.000000000 -05:00
type: post
published: true
status: publish
categories:
- R
tags:
- Misc
- R
- R Quirks
author: wrathematics
---


R is full of things that make "real programmers" (I dislike this term) turn their noses up in disgust. One of my favorites is the `dump()` function. It is...odd. I think the best way to introduce it to people is without context, because it's just so bizarre:

```R
x <- runif(5)

x
## [1] 0.7169493 0.1615495 0.7741029 0.4234200 0.8732784

dump("x", stdout())
## x <-
## c(0.716949315741658, 0.161549518117681, 0.774102924391627, 0.423419966362417,
## 0.873278449522331)

y <- matrix(1:30, 10)
dump("y", stdout())
## y <-
## structure(1:30, .Dim = c(10L, 3L))
```

That's right; it's actually dumping out R code that would allow you to generate the object. I have actually even found some intersting uses for this in my time developing R packages. But they are highly unusual, and generally I would recommend you rethink your strategy if you think this looks like a solution to your problems. Still, it's pretty cool to have!

But this allows for another amusing oddity with R: you can modify R objects with a text editor *inside the R terminal itself*. Here's a simple example:

```R
x <- 1:5
vi(x)
```

Entering this into an R terminal will greet you with a vim editor containing the text:

```
1:5
```

Now if I change the 5 to a 6 and save/exit, back in R I see:

```R
vi(x)
# [1] 1 2 3 4 5 6
```

There are also `emacs()` and `xemacs()` functions if you're some kind of filthy emacs plebian. I mean, they probably work. I wouldn't know:

```
$ apt-cache policy emacs
## emacs:
## Installed: (none)
## ...
```

Now these editor commands (`vi()`, `emacs()`, ...) sort of work in RStudio, but not really (you just get a plain editor window). So you will have to use your terminal to really enjoy this one.

Speaking of RStudio, did you know that it has a vim mode? It's far from a full vim session, but it's pretty neat. You can enable it by selecting

-   Tools
-   Global Options
-   Code Editing
-   Enable vim editing mode:

![rstudio_vim]({{ site.baseurl }}/assets/rstudio_vim.png)

Of course, there's a [nice R plugin for vim itself](http://www.vim.org/scripts/script.php?script_id=2628).
