---
layout: post
title: Controlling a Remote R Session from a Local One
date: 2015-10-28 07:58:52.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Computer Science
- pbdR
- R
author: wrathematics
---


Say you have an Amazon EC2 instance running and you want to be able to control your R session running there from your local R session. At heart, this is not a new idea for the R community. You can already control remote R sessions easily with [Shiny](http://shiny.rstudio.com/) or [RStudio server](https://www.rstudio.com/products/RStudio/#Server), for instance. Well now you can also try the experimental [remoter](https://github.com/wrathematics/remoter) package, available on github. So while this isn't really tackling an unsolved problem, I think this approach, for better or worse, is unique.

You use it basically just like it says in the [readme](https://github.com/wrathematics/remoter/blob/master/README.md). The basic idea is to ssh to your remote and start up a server (I recommend using tmux for this, but you could just use fork with something like `Rscript -e "remoter::server()" &`). Once that's done, you connect from your local R session with `remoter::client("my.remote.address")`. This ignores the usual issues, like port forwarding, which of course are relevant.

The package uses ZeroMQ by way of [pbdZMQ](https://github.com/snoweye/pbdZMQ) to handle communication in a Request/Reply client/server pattern. There's also a custom R REPL to automatically handle intercepting the local command, broadcasting it, executing it, and communicating back the return. The REPL design is kind of complicated, because it was actually designed for another purpose entirely, namely managing multiple batch MPI servers from a single client in the [pbdCS](https://github.com/wrathematics/pbdCS) package. remoter is just pbdCS with all the MPI/multiple server stuff stripped out.

I don't know if I'd be willing to use remoter in any kind of production environment; it's more a cool proof of concept than anything really. On the other hand, if you're into using R on supercomputers, you might want to keep an eye on pbdCS and friends.
