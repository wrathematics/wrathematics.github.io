---
layout: post
comments: true
title: Statistical Software Popularity on Google Scholar
date: 2012-04-12 08:00:07.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- ggplot2
- R
- Shell Scripting
- Visualization
author: wrathematics
---


**Background (probably boring)**

Several months ago, my [boss](http://r4stats.com) and I were discussing how he got the data for his[software popularity](http://sites.google.com/site/r4statistics/popularity) article; the rest of the background discussion pertains to those plots, so I would recommend going over to take a look before continuing on (or just skip to the next section if you're impatient).  Specifically, we were talking about his figures 7 and 11.  Basically he was manually performing searches and recording whatever value he was interested in---by hand---like some kind of barbarian.  This is a bad idea for at least 3 reasons:

1.  It's a waste of time to scrape the web manually.  Writing a web     scraper, especially if what you want to scrape is very uncomplicated     (as is the case here), is easy in pretty much every scripting     language.  Spending a little time up front in developing a scraper     will quickly pay dividends.
2.  If you ever want to change your operational definition (in this     case, these are effectively the search queries), then you have to go     grab all the old data.  This is especially awful if you are trying     to get a sense for how things perform over time (as we are here).      With a scraper, this is no problem.  By hand, this could be *hours*     of laborious, menial work.
3.  This is the reason computers were invented!  Put down that mouse and     open up vim! (I have heard that emacs has similar capabilities to     vim, although unfortunately I was never able to test this myself     since I could not find the text editor in the emacs     operating system).

There's another good reason to do this with a scraper instead of by hand, but it is more specific to our particular task.  Search engine queries are not going to produce the same results across different days.  It just doesn't work that way for a whole host of reasons.  So if, as here, you decide to look at the number of Google Scholar hits for  various searches across years, you have to grab all years at once for a sort of "snapshot" in time of how google is deciding to index things on that day.  If you grab historical data and slowly build on it (as had been done), then any inference is dubious.

For that matter, it is probably a good idea to point out that this data is a description of exactly what we are saying; it is an examination of Google Scholar hits for various queries.  I would hesitate to say that this describes the world of publishing at large, although given Google's monstrous scope in all things they do, I would not be surprised if this were such a reflection (I'm just not claiming that it is!). 

Additionally, again given that search engines are, as far as the end user is concerned, mystical voodoo, I don't necessarily trust the numbers given here in absolute terms.  I might be inclined, however, to put more faith in the relative growth/decay.  Although even that is odd.  If you look at the timeplot in the [software popularity article](http://sites.google.com/site/r4statistics/popularity), you will see a *massive* spike and then equally massive cratering of SPSS.  Why might this be?  I suppose the economy could be partly to blame (research funds are drying up everywhere and have been for some time), but certainly not entirely.  I have no idea what would cause such a sharp rise and then fall except that maybe searching for "SPSS" is hitting a lot of false positives, in addition to some other spectrum of explanations.

SAS has a somewhat similar behavior, although certainly not as pronounced.  The SAS one is a little more believable.  It is reasonable to think that the crash of the global economy hurt SAS, and that, for SAS Institute, this couldn't have come at a worse time, since competitors such as R are steadily eating away at the SAS userbase.  But I'm still not sure that's a complete explanation for the behavior seen here either.

What I'm saying is that you should probably take these numbers with a grain of salt.

Finally, there are a few changes here over his previous versions of that graph.  If you had seen it before, you would have seen stata in a much stronger position.  This is because we had been getting a *lot* of false positives because the word "stata" is the conditional perfect form of the verb "to be" in Italian.  [No, seriously.](http://italian.about.com/library/verb/blverb_essere.htm)  Some other less noticeable changes were made, but all of them are completely transparent in the scraper code posted at the end of this blog.  You can see exactly what we did and how we did it, and then angrily post to your newsgroup and/or bbs of choice about it, you giant nerd. 

**The Data**

Ok, so now that boring crap you skipped is out of the way, let's talk about the data.  The most recent data was collected on Monday, April 9th at around 4:00pm EDT.  [You can grab your very own copy of the data here](http://librestats.com/wp-content/uploads/2012/04/scholarly_impact_2012.4.9.csv).  I'm not sure why you would want it, but why does anyone want anything.  A timeplot of this data is over at [the software popularity article.](http://sites.google.com/site/r4statistics/popularity)  But who cares; timeplots are for boring nerds.  The real sweetness is in this sexy thing:

![]({{ site.baseurl }}/assets/marketshare.png "marketshare")

Isn't that beautiful?  Made, of course, with [the amazing ggplot2 package for R](http://had.co.nz/ggplot/).  I'm not sure what this type of plot is called.  It probably has a name, but I've always called it a "market share plot", since that's basically how they're used.  Anyone who's ever played [Civilization  III](https://en.wikipedia.org/wiki/Civilization_III) will be very familiar with these kinds of plots (they also show up a lot in political horse races).

Basically, as the name sort of suggests, the horizontal slices are capturing a sense for how much market share (proportional use) each software has in that time frame.  To make your very own sexy market share plot using the example data set linked above (and again [here](http://librestats.com/wp-content/uploads/2012/04/scholarly_impact_2012.4.9.csv) since I know you're lazy), you could do something like this:

```R
library(ggplot2)
library(reshape2)
library(scales)

Scholar <- read.csv("scholarly_impact_2012.4.9.csv")

Little6 <- c("JMP","Minitab","Stata","Statistica","Systat","R")
Subset <- Scholar[ , Little6]
Year <- rep(Scholar\$Year, length(Subset))
ScholarLong <- melt(Subset)
names(ScholarLong) <- c("Software", "Hits")
ScholarLong <- data.frame(Year, ScholarLong)

#png("marketshare.png")
ggplot(ScholarLong, aes(Year, Hits, group=Software)) +
  geom_smooth(aes(fill=Software), position="fill") +
  coord_flip()+
  scale_x_continuous("Year", trans="reverse") +
  scale_y_continuous("Proportion of Google Scholar Hits For Each
  Software", labels = NULL)+
  opts(title = expression("Market Share"), axis.ticks = theme_blank())
#dev.off()
```

Now maybe this type of data (for the reasons outlined above in the boring part) isn't *really* appropriate for this kind of plot, but at the very least we can appreciate it as a gorgeous plot, even if we don't entirely trust it.

**The Scraper**

****Ok, so finally, here's the code for the scraper.  Most of you can safely ignore this because, no, I didn't write it in R---I wrote it in shell.  Some people seem to get very angsty when anyone does anything outside of R.  R is *amazing* at what it does.  I'm one of R's biggest fans, but there are some tasks that, in my opinion, are just better suited for the shell.  Yes I know I can just use system(), but I don't want to.  Stop complaining so much, voice in my head.

The shebang here is for bash, but it probably will work in less robust shells.  If you're the kind of weirdo who insists on avoiding bash, then this should satisfy you.

```bash
#!/bin/bash

# For each year starting from the given first year up to the given last year, this script
# scrapes google scholar for chosen search strings.

# ----------------------------------------
# Changeable options
# ----------------------------------------

# SEARCH STRINGS: Separate queries by a space; enclose in quotes with %22; use + for space;
queries="
BDMP
JMP+AND+%22SAS+Institute%22
Minitab
SPSS
%22SAS+Institute%22+-JMP
Statacorp
%22Statsoft+Statistica%22
Systat
%22the+R+software%22+OR+%22the+R+project%22+OR+%22r-project.org%22+OR+hmisc+OR+ggplot2+OR+RTextTools
%22s-plus%22%2Btibco+OR+%22s-plus%22%2B%22insightful%22
"

# QUERY NAMES: What the column titles in the first row of the output .csv should be.
# Order should match order of queries above. This only affects the way the output file looks.
qnames="
BDMP
JMP
Minitab
SPSS
SAS
Stata
Statistica
Systat
R
SPlus
"

# First and last years to consider
firstyear="1995"
#lastyear=\`date | awk -F " " '{print \$6}'\` # Current year
lastyear=\`date | awk -F " " '{print \$6}'\`; lastyear=\$(( \$lastyear - 1 )) # Previous year

workdir=/tmp
outdir=\~/scraper/google

# ----------------------------------------
# Don't touch
# ----------------------------------------
firstrun=TRUE
cd \$workdir

mon=\`date | awk -F " " '{print \$2}' | sed -e 's/Jan/1/' -e 's/Feb/2/'
-e 's/Mar/3/' -e 's/Apr/4/' -e 's/May/5/' -e 's/Jun/6/' -e 's/Jul/7/' -e
's/Aug/8/' -e 's/Sep/9/' -e 's/Oct/10/' -e 's/Nov/11/' -e 's/Dec/12/'\`
day=\`date | awk -F " " '{print \$3}'\`
yr=\`date | awk -F " " '{print \$6}'\`

# Output file: current month.day.year.csv
#outfil="scholarly_impact_\${mon}.\${day}.\${yr}.csv" #original outfile name
outfil="scholarly_impact_\${yr}.\${mon}.\${day}.csv"

if [ ! -e \${outdir}/\${outfil} ]; then
  touch \${outdir}/\${outfil}
  echo -n "Year," >> \$outdir/\$outfil
  for q in \$qnames; do
    echo -n "\$q," >> \$outdir/\$outfil
  done

  sed -i 's/.\$//' \$outdir/\$outfil
  echo "" >> \$outdir/\$outfil

else
  echo -e
  "

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo -e "!\\t\\tWARNING: OUTPUT FILE EXISTS\\t\\t !
  ! New output will
  be appended--this shouldn't be happening !"
  echo -e
  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  "
  echo -e "Giving you 10 seconds to change your mind...
  "
  sleep 10
fi

years=""
for (( year=\${firstyear}; year<=\${lastyear}; year++ )); do
  years="\$years \$year"
done

for year in \$years; do
  numbers=""
  for query in \$queries; do

    # Waits between 10 and 20 seconds before continuing
    if [ \$firstrun = FALSE ]; then
      sleepfullsecs=\$[ \$RANDOM % 11 + 10 ]
      sleepfracsecs=\`echo "scale=4; \$[ \$RANDOM % 10000 ] /10000" | bc
      -l\`
      sleepsecs=\`echo "\${sleepfullsecs}\${sleepfracsecs}"\`
      echo -e "

      Sleeping for \$sleepsecs seconds so we don't get flagged
      as a bot.
      "
      for (( sleepy=\${sleepfullsecs}; sleepy>=1; sleepy-- )); do
        echo -n \$sleepy
        sleep .25; echo -n "."
        sleep .25; echo -n "."
        sleep .25; echo -n "."
        sleep .25
      done
      echo -n "0 and 0\$sleepfracsecs"; sleep \$sleepfracsecs; echo -e
      "

      "
    else if [ \$firstrun = TRUE ]; then
      firstrun=FALSE
    fi;fi

    url="http://scholar.google.com/scholar?hl=en?&num=1&q=\${query}&btnG=Search&as_sdt=1%2C43&as_ylo=\${year}&as_yhi=\${year}&as_vis=1"
    #wget --user-agent=\${useragent} --referer=\$referer
    --output-document=goog --tries=20 \$url
    wget --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US;
    rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"
    --referer="http://scholar.google.com/" --output-document=goog --tries=20
    \$url

    # Query may find nothing
    teststring=\`awk -F "No pages were found containing" '{print \$2}'
    goog\`
    if [ "\$teststring" = "" ]; then
      sed -n -i 's/.*Results <b>1<\\/b> - <b>1<\\/b>
      of //p' goog
      sed -i -e 's/about //' -e 's/<b>//' -e 's/,//g' goog
      number=\`awk -F "</b>" '{print \$1}' goog\`
    else
      number=0
    fi

    numbers="\${numbers},\$number"
    echo -e "

     Number found: \$number 

    "
    rm goog
  done
  echo "\${year}\${numbers}" >> \${outdir}/\${outfil}
done
```
