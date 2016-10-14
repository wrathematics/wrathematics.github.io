---
layout: post
comments: true
title: 'Project Euler in LaTeX:  Problem 2'
date: 2012-05-01 20:32:53.000000000 -04:00
type: post
published: true
status: publish
categories:
- LaTeX
- Project Euler Solutions
tags:
- fibonacci numbers
- LaTeX
- Project Euler
author: wrathematics
---


I probably won't do any more of these, and I hadn't really planned on even doing this one, but I've been inspired. Apparently [some Russians](http://www.chemport.ru/forum/viewtopic.php?f=1&t=19556&p=616847) found [my first post about doing Project Euler problems in LaTeX](http://librestats.com/2012/04/23/project-euler-in-latex/ "Project Euler...in LaTeX?"). According to google translate, my post was described as being part of "the horrors of our Internet" that our comrade stumbled on inadvertently through searching for something completely unrelated. He finishes his post (according to google translate) by saying "see what perverts are in the world."

Honestly, I think this is hilarious, and in the hopes of conning yet more unsuspecting Russian youths into my web of perversion, I present to you the solution, in LaTeX, to the second Project Euler problem.

The second problem asks us to sum up all of the even-valued Fibonacci Numbers. This is surprisingly not that hard to do in LaTeX. The one catch is that the forloop macro doesn't have a while loop. Rigging up a while loop from a for loop is easy enough. The whole thing is fairly straight forward.

```tex
\section{Solution}

\newcounter{sum}

\newcounter{current}

\newcounter{prev}

\newcounter{prevprev}

\newcounter{n}

\FPset{\sum}{0}
\FPset{\prev}{1}
\FPset{\prevprev}{1}
\FPset{\current}{2}

\forloop{n}{1}{\value{n} < 2}{ % a makeshift while loop
\FPdiv{\test}{\current}{2}
\FPifint{\test} \FPadd{\sum}{\sum}{\current} \fi

\FPset{\prevprev}{\prev}
\FPset{\prev}{\current}
\FPadd{\current}{\prev}{\prevprev}

\FPiflt{\current}{4000000} \setcounter{n}{0} \fi
}

\FPround{\sum}{\sum}{0}

The sum of all even valued Fibonacci Numbers below 4,000,000 is
\FPprint{\sum}.

\end{document}
```

[And here is the compiled pdf.](http://librestats.com/wp-content/uploads/2012/05/pe2.pdf)

One final note, our Russian friend also said that the code from the first post threw a bunch of errors. It shouldn't. I think there was a bad box in that one, but there definitely shouldn't be errors. There might be issues with using the CTAN macros in Miktex (I use TeX Live with EVERYTHING installed).
