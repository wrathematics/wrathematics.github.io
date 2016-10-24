---
layout: post
comments: true
title: '"F-bombs" in GitHub Commits (warning: contains profanity)'
date: 2014-07-30 07:06:49.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Misc
- R
- Visualization
author: wrathematics
---


<span style="text-decoration: underline;">**Warning**</span>: this post contains profanity...arguably excessive amounts of it.  If you are a humorless no-fun, you are recommended to proceed no further.

Seriously though, the title is quite descriptive of the content of this post.  If you are offended by the use of such language, or if your boss is likely to come peering over your shoulder soon, I don't recommend you proceed.

 

"F-Bombs" in Public GitHub Commits
==================================

So over on Reddit, I found some posts by [Max Woolf](http://minimaxir.com/) where he was able to get all public GitHub commits containing the word "fuck" (also some extra data with "shit") from 3/11/2012 to 7/24/2014.  He posted the [raw commit data](https://docs.google.com/spreadsheets/d/1NDKNmTS25Ijqay3BjB6c6N1MeunFgDWQcqijCOSRLVk/edit?usp=sharing), and was even kind enough to [explain how he got the data in the first place](http://www.reddit.com/r/ProgrammerHumor/comments/2bpkdh/languages_with_the_most_curse_words_in_the_git/cj809jq).  He also provided a hilarious plot, showing the [Languages with Most F-Bombs and S-bombs in Commit Messages](https://www.facebook.com/photo.php?fbid=10152572618920450&set=a.432190050449.225968.582270449&type=1&theater).

I so fell in love with this data that I decided to put the data into an [R package](https://github.com/wrathematics/idgaf) for even easier access.  Just poking at it, I was quickly able to answer some simple questions I had, including...

 

How many fucks do developers give?
==================================

![numf]({{ site.url }}/assets/numf.png)

 

What's the most common fuck to give?
====================================

![commits]({{ site.url }}/assets/commits.png)

 

Who gives the most fucks?
=========================

If we look at the users whose commits contain the most instances of "fuck", there is certainly a clear victor:

![who_user]({{ site.url }}/assets/who_user.png)

Let's group users by their repos (e.g.,
[hadley/devtools](http://github.com/hadley/devtools) --- and no, he's
not on the list).  Maybe this way we'll see a different pattern...

Nope, same guy:

![who_repo]({{ site.url }}/assets/who_repo.png)

I'm tempted to look at that repo, but I'm afraid I'll instantly lose my sanity, like some kind of rejected H. P. Lovecraft story.

 

Emergent fucks
==============

Not enough variety in the dataset for you?  Try using the [ngram](http://cran.r-project.org/web/packages/ngram/index.html) package to use markov chains generate some new fucks, and other assorted nonesense.

Typical systems programmer:

> *This simplifies MT based class systems, and drastically improves performance on luajit as it will get, I should say), and I have over 300 confirmed kills.*

Another typical systems programmer:

> *fuckfuckfuckfuck STATIC MOTHER FUCKER STATIC MOTHER FUCKER STATIC MOTHER FUCKER STATIC MOTHER FUCKER fucking shitfucks fucking shitfucks fucking shitfucks fucking typos fucking typos fucking typos fucking typos fuckckck fuckckck fuckckck fuckckck typo fuck typo fuck typo fuck typo fuck handle version fuckups better handle version fuckups better damn fuck damn fuck damn fuck damn fuckfuckfuckfuckfuck fucking coverage...*
