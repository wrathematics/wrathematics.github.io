---
layout: post
comments: true
title: 'Visualizing the CRAN:  Graphing Package Dependencies'
date: 2012-05-17 23:39:01.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- R
- Shell Scripting
- Visualization
author: wrathematics
---


I had been meaning to start toying with the [igraph](http://igraph.sourceforge.net/) package for a while. So a few weeks ago (lay off, I'm busy), I decided to grab a bunch of CRAN data about package dependencies. The easiest way that I could think to get this information was to just grab the html files for all the package descriptions and chop through them.

Quick note before I forget: I'm not looking at any base packages. Only packages in the CRAN in the pictures to follow.

Much of this information can be gathered from installed.packages(), assuming of course you have every package installed (and if you're on Windows, that's impossible). This also requires you to download gigabytes of data, rather than my method which yanks about 60mb of html.

I'll get to just how I scraped the data in a bit, but first, the pictures. If you are interested in the igraph package, you should really stop tooling around dumb boring blogs like this one and read [the documentation](http://cran.r-project.org/web/packages/igraph/igraph.pdf), because it is a real gem. This is the gold standard for all aspiring R package developers out there.

Before we get going, here's the [dataset](http://librestats.com/wp-content/uploads/2012/05/cran_dep_data.tar.gz) in case you want to follow along. Quick warning, I don't recommend you try to open this up in a spreadsheet program. Uncompressed, the dataset is 30mb and is basically a 4000x4000 matrix (compressed it's just a few hundred kb). A quick note about the dataset; it is a matrix consisting of the numbers 0, 1, and 2.  A 0 means there is no relation between packages, a 1 means there is a dependence between packages, and a 2 means that one package suggests another.  More specifically (with dependence as an example), the entry X[m,n] = 1 means that the package at row m depends on the package at column n. 

Ok, so pretty picture time.  Quick note, for the purpose of displaying these on a webpage, I can't use nice high quality pdf's.  So I have to use png's, which really blow up in file size if I attempt to have any kind of reasonable resolution.  But this should give you some idea of how things look, anyway.

So this is probably no surprise to you, but MASS is the most "depended on" package on the CRAN.  A total of 294 of the 3794 packages (almost 8%) in the CRAN depend on MASS.  An additional 95 suggest MASS; so just over 10% of all R packages either suggest or depend on MASS. 

That's neat and all (actually it's crazy impressive), but I want a pretty graph.  Here's a link diagram of all the packages that depend on MASS

![]({{ site.baseurl }}/assets/mass.png "mass")

Which really is quite impressive. Here (and throughout), A-->B means B depends on A.  Another package that is near and dear to my heart is Dr. Hyndman's amazing [forecast package](http://cran.r-project.org/web/packages/forecast/index.html).  Here's a linkage graph for all packages that depend on and suggest forecast

![]({{ site.baseurl }}/assets/forecast.png "forecast")

I even included [CRAN taskview](http://cran.r-project.org/web/views/) diagrams.  Here's the linkage diagram for the machine learning taskview

![]({{ site.baseurl }}/assets/ml.png "ml")

I made a little function that's mostly coherent (lay off, I'm busy) so you can visualize your own package. Or spy on someone else's. I'm not here to judge you, friend.

```R
showlinkage <- function(df, package, suggests=FALSE, task=NULL, include.self=TRUE){
  require(igraph)

  tasks <- x[(ncol(df)-28):ncol(df)]
  df <- df[1:(ncol(df)-29)]

  if (!suggests){
    df[] <- lapply(df, function(x){replace(x, x == 2, 0)})
  } else {
    df[] <- lapply(df, function(x){replace(x, x == 2, 1)})
  }

  if (!is.null(task)){
    task <- paste("taskclass", task, sep="")
    rc <<- which(tasks[which(colnames(tasks)==task)]==1)
    df <- df[rc, rc]
  }

  if (package != "ByTask"){
    df <- df[c(which(df[package]==1 | rownames(df)==package),
    which(df[which(rownames(df)==package), ]==1)),
    c(which(df[package]==1 | rownames(df)==package),
    which(df[which(rownames(df)==package), ]==1))]
    if (!include.self){
    df <- df[-which(rownames(df)==package),
    -which(colnames(df)==package)]
    }
  }

  df <- t(df) # reverse linkage arrows

  g <- graph.adjacency(df, mode="directed", weighted=TRUE,
  add.rownames=TRUE)

  plot(g, vertex.label.color="blue",
    edge.width=.5, edge.color="#ACC49D", edge.arrow.size=.5,
    vertex.label.cex=.7, vertex.label=row.names(df), vertex.size=0,
    vertex.color="white",
    #layout=layout.reingold.tilford
    layout=layout.kamada.kawai
  )
}
```

So for the first MASS graph, you would do

```R
showlinkage(x, "MASS", include.self=TRUE, suggests=FALSE)
```

Setting include.self to FALSE here would drop MASS from the diagram, so you could see the relationship of all the packages that depend on MASS without having MASS sitting there in the diagram with all its...erm...mass.

For the taskview stuff, you would do

```R
showlinkage(x, "ByTask", include.self=TRUE, suggests=FALSE, task="MachineLearning")
```

So what about all of the CRAN dependencies at once?  This is harder to do because there's just *SO MUCH STUFF* out there in the CRAN.  Now, as it turns out, just over 71% of all packages aren't dependencies for other packages.  So while there is a STAGGERING amount of package inbreeding out there, still the majority of packages are lonely little islands.

Given the volume of stuff we're working with here, we need to think about the layout algorithm.  That is, we *would* have to, except the handsome people on the igraph project already did the thinking for us, saving our brain cells for pop songs and beer.

Going through a few of the different options for layout algorithms, we can get different insights into these CRAN linkages.  First, using layout.fruchterman.reingold

![]({{ site.baseurl }}/assets/1.png "1")

Next with layout.circle (which for this data is kind of dumb, but you really get a sense for how much linking is going on)

![]({{ site.baseurl }}/assets/3.png "3")

We could also do layout.graphopt

![]({{ site.baseurl }}/assets/4.png "4")

And for my last example, layout.drl

![]({{ site.baseurl }}/assets/5.png "5")

Of course, if you have the dataset, you can tinker with these options some more and plot in your very own way.  For these graphs, assuming you store the csv in the object x, you might do something like:

```R
y <- x[1:(ncol(x)-29)]
y[] <- lapply(y, function(x){replace(x, x == 2, 0)})

g <- graph.adjacency(y, mode="directed", weighted=TRUE, add.rownames=TRUE)

plot(g,
  edge.width=.5, edge.color="#ACC49D", edge.arrow.size=.5,
  vertex.label.cex=.7, vertex.label="", vertex.size=1,
  vertex.color="black",
  layout=layout.fruchterman.reingold
)
```

which would reproduce the first plot.

Well, in my usual fashion, here's how I grabbed up all the data. In the past I have used shell to do my data scraping because I can script these things out in about 5-10 minutes in shell. Things are no different this time (have I mentioned that I am busy?), so that's what you get.

```bash
#!/bin/sh

# -------------------------------------------------------
# setup/mirroring
# -------------------------------------------------------

outdir="wherever"
cd \$outdir
touch out.csv

wget -e robots=off -r -l5 --no-parent -A.html
http://cran.r-project.org/web/packages

mirloc="cran.r-project.org/web/packages"

# -------------------------------------------------------
# outfile setup
# -------------------------------------------------------

packages=\`ls \$mirloc\`

for p in \$packages;do
  echo -n "\$p," >> out.csv
done

tasks=\`cat \$mirloc/../views/index.html | grep "</a>" | sed -e
's/<[^>]*>//g'\`

echo -n "PackageName" >> out.csv

for t in \$tasks;do
  echo -n "taskclass\$t," >> out.csv
done

sed -i 's/.\$//' out.csv

echo "" >> out.csv

# -------------------------------------------------------
# generating data for the adjacency matrix
# -------------------------------------------------------

for prow in \$packages;do
  out=""

  depends=\`grep -A 1 "<tr><td valign=top>Depends:</td>"
  -i \$mirloc/\$prow/index.html | tail -n 1 | awk -F "," '{ \$1=""; print
  \$0 }' | sed -e 's/<[^>]*>//g' -e 's/([^)]*)//g'\`
  suggests=\`grep -A 1 "<tr><td
  valign=top>Suggests:</td>" -i \$mirloc/\$prow/index.html | tail
  -n 1 | awk -F "," '{ \$1=""; print \$0 }' | sed -e
  's/<[^>]*>//g' -e 's/([^)]*)//g'\`

  echo -n \$prow >> out.csv

  for pcol in \$packages;do
    isin=0
    for d in \$depends;do
      if [ \$pcol = \$d ];then
        isin=1;break
      fi
    done
    for s in \$suggests;do
      if [ \$pcol = \$s ];then
        isin=2;break
      fi
    done
    out="\$out,\$isin"
  done

  taskview=\`grep -r "\${prow}</a>" \$mirloc/../views/*.html | awk -F ":" '{print \$1}' | uniq | sed -e 's/.html//' -e 's/.*\\///g'\`
  for t in \$tasks;do
    isin=0
    for tv in \$taskview;do
      if [ \$tv = \$t ];then
        isin=1;break
      fi
    done
    out="\$out,\$isin"
  done
  echo \$out >> out.csv #| sed 's/,//' >> out.csv
done
```
