---
layout: post
comments: true
title: 'Introducing Rfiglet: ASCII logos from the comfort of R'
date: 2014-08-19 06:22:50.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Misc
- R
- shiny
author: wrathematics
---


The Rfiglet Package
===================

For those who don't know what [figlet](http://www.figlet.org/) is, it's a command line utility for creating ascii logos.  [Rfiglet](https://github.com/wrathematics/Rfiglet), therefore, is a set of R bindings for figlet.

Works about like you would expect:

```R
library(Rfiglet)
figlet("ascii")

#                _ _
#  __ _ ___  ___(_|_)
# / _\` / __|/ __| | |
#| (_| \\__ \\ (__| | |
# \\__,_|___/\\___|_|_|
```

There are over 150 fonts available, and you can see an example of each one in [this Rfiglet package vignette](https://cdn.rawgit.com/wrathematics/Rfiglet/master/inst/doc/figlet_fonts.html).

We can even use our ascii art with another ascii package that emulates a command line utility, [cowsay](https://github.com/sckott/cowsay):

```R
library(cowsay)
library(Rfiglet)

say(paste(figlet("longcat is long"), collapse="
"), "longcat")

## ----- 
## _                             _     _       _                   
## | | ___  _ __   __ _  ___ __ _| |_  (_)___  | | ___  _ __   __ _ 
## | |/ _ \| '_ \ / _` |/ __/ _` | __| | / __| | |/ _ \| '_ \ / _` |
## | | (_) | | | | (_| | (_| (_| | |_  | \__ \ | | (_) | | | | (_| |
## |_|\___/|_| |_|\__, |\___\__,_|\__| |_|___/ |_|\___/|_| |_|\__, |
##               |___/                                       |___/  
## ------ 
##    \   
##     \
##    .ﾊ,,ﾊ
##    ( ﾟωﾟ)
##    |つ  つ
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    |    |
##    U "  U
##        [BoingBoing]
```

For those of you who are familiar with integrating compiled code into R, you may find [my approach in this package](https://github.com/wrathematics/Rfiglet/blob/master/R/figlet.r#L23-L32) somewhat amusing/horrifying.

 

Figlet as a Service
===================

[As we all know](http://librestats.com/2014/08/06/a-new-use-for-pipes-in-r-forkbombs/), software's out and services are in.  That's why I also created [Figlet as a Service](https://wrathematics.shinyapps.io/faas/).  Ascii is finally ready for the enterprise.
