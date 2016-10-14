---
layout: post
comments: true
title: 'A New Use for Pipes in R: Forkbombs'
date: 2014-08-06 12:41:40.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Misc
- R
author: wrathematics
---


Almost 3 years ago, I wrote about [how to forkbomb with R](http://librestats.com/2011/09/14/r-fork-bomb/). A quick recap is that a [forkbomb](https://en.wikipedia.org/wiki/Fork_bomb) is a low-tier, malicious misuse of a system; sort of a "baby's first denial of service". The idea is that you write a program that will start an entirely new copy of itself each time it is executed. Executing it will quickly gobble up all available resources, generally locking up the system.

Naturally this is one of my favorite things ever.

Perhaps the most famous forkbomb is the one for *NIX shell by [Denis Roio](https://en.wikipedia.org/wiki/Jaromil):

```bash
:(){ :|:& };:
```

Many people consider this small piece of malicious code a work of art. Wait until they see the "art" my cat makes when he wants me to stop programming (I kid; I actually think it's beautiful).

The way it basically works is that `:(){}` is defining a function, which works by calling itself recursively in the background (via fork), causing your system to spawn shells until it's overwhelmed. With [magrittr](http://cran.r-project.org/web/packages/magrittr/index.html), we can kind of emulate this syntax:

```R
library(parallel)
library(magrittr)

"&" <- function(.) parallel:::mcfork(T)
":" <- function(.) {\`&\`() %>% \`:\`()};\`:\`()
```

I admit it's far from a perfect match, but it'll do.  Because of the call to fork, this will only work on *NIX-likes (i.e., not Windows).  If you want to test this, I would recommend setting `ulimit -u 1000` (or
thereabouts) in your shell first.  Last I heard Macs do something like this by default.

But as we all know, software's out and services are in. With that in mind...

 

Forkbomb as a Service
=====================

We are proud to announce our latest enterprise-ready solution that scales to your competencies. Worried about how to waste the rest of your budget at the end of the year to avoid dreaded cutbacks? Using leading cloud analytics solutions, we dramatically conceptualize granular, market-driven technology by appropriately incubating professional meta-services. We will spin up an Amazon EC2 instance scaled perfectly to your needs, and through efficient webscale engineering, we will forkbomb it, backed by our uptime-to-downtime guarantee. 

FBaaS wastes money better than a team of Java developers. If you're a lean enterprise with a startup culture always on the lookout for disruptors, let us help you actualize your multi-level strategies with our distinctively evolving synergistic web technology. Our best-of-breed functional meta-services synergize with interoperable progressive deliverables, enabling your business to dramatically iterate on convergence and reliably target long-term, next-generation, multi-functional paradigms.

Is your enterprise ready for the game-changer that is FBaaS? [Contact us today](mailto:ceoK00lguy96@seriouscompany.internet).
