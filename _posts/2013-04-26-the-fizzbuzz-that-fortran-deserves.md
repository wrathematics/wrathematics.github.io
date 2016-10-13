---
layout: post
title: The fizzbuzz that Fortran Deserves
date: 2013-04-26 16:53:57.000000000 -04:00
type: post
published: true
status: publish
categories: []
tags:
- Fortran
- Programming
author: wrathematics
---


I've talked about the toy programming problem [fizzbuzz](https://en.wikipedia.org/wiki/Bizz_buzz) on this blog a few times. In R, you might do something like this:

```R
for (i in 1:100){
  if (i%%3==0) # divisible by 3
    if (i%%5==0)
      print("fizzbuzz")
    else
      print("fizz")
  else if (i%%5==0)
    print("buzz")
  else
    print(i)
}
```

Or to be a bit more R-ish, you might do something like:

```R
f <- function(i){
  if (i%%3==0)
    if (i%%5==0)
      return("fizzbuzz")
    else
      return("fizz")
  else if (i%%5==0)
    return("buzz")
  else
    return(i)
}
 
sapply(1:100, f)
```

But there's a problem. That's all too readable! When I look at it, I know exactly what it's doing.

Enter Fortran.

I spend most of my life programming in Fortran these days --- which I then hook into R via C wrappers in a cumbersome process that I don't wish on my enemies. Anyway, the point is Fortran is really nice for matrix operations, and a hideous monstrosity for most everything else. Especially old Fortran, like Fortran 77. It tends to be full of [GOTO](https://en.wikipedia.org/wiki/Goto) statements that make reading the program an impossibility.

So that's precisely why I developed a fizzbuzz in Fortran, using nothing but GOTO's, IF's, FORMAT, and WRITE statements:

```fortran
* THIS PROGRAM IS COPYWRITE ME ALL YEARS DON NOT COPOY!!!!
      PROGRAM GOTOHEL
      I
     $  N
     $    T
     $      E
     $    G
     $  E
     $R A
     $,B
      PARAMETE
     $ R     (
     $  A =
     $ 3,B=5 ,
     $M=10
     $0)
 3290 FORMAT(A,F5.3)
      GOTO 1209
 7365 CONTINUE
      WRITE (*,3290) " "
      GOTO 7356
 1121 FORMAT(I4,F8.3)
 3298 CONTINUE
      IF(MOD(I,A)
     $.EQ.Z) THEN
      GOTO 2359
      ELSE IF(MOD(I,B)
     $.EQ.Z) THEN
      GOTO 8125
      ELSE
      WRITE (*,2930) I
      GOTO 7365
      END IF
 7235 FORMAT(A,F5.3)
 7356 CONTINUE
      I=I
     $+1
      GOTO 1249
 2930 FORMAT(I4,$)
 2359 CONTINUE
      WRITE (*,2390) "FIZZ"
      IF (MOD(I,B)
     $.EQ.Z) THEN
      GOTO 8125
      END IF
      GOTO 7365
 1249 CONTINUE
      IF(I.GT.M) THEN
      GOTO 3285
      ELSE
      GOTO 3298
      ENDIF
 2390 FORMAT(A,$)
 1209 CONTINUE
      WRITE (*,2930) 1
      I=I+1
      GOTO 7365
 8125 CONTINUE
      WRITE (*,2390) "BUZZ"
      GOTO 7365
 3285 CONTINUE
      END
```

This will compile with gfortran and gnu f77, so to all the enterprises
out there still depending on Fortran 77, this code is just for you!
Here's an example proving that this does indeed work:

```bash
user@localhost$ f77 fizzbuzz.f
   MAIN gotohel:
user@localhost$ ./a.out 
   1 
   2 
FIZZ 
   4 
BUZZ 
FIZZ 
   7 
   8 
FIZZ 
BUZZ 
  11 
FIZZ 
  13 
  14 
FIZZBUZZ 
  16 
  17 
FIZZ 
  19 
BUZZ 
FIZZ 
  22 
  23 
FIZZ 
BUZZ 
  26 
FIZZ 
  28 
  29 
FIZZBUZZ 
  31 
  32 
FIZZ 
  34 
BUZZ 
FIZZ 
  37 
  38 
FIZZ 
BUZZ 
  41 
FIZZ 
  43 
  44 
FIZZBUZZ 
  46 
  47 
FIZZ 
  49 
BUZZ 
FIZZ 
  52 
  53 
FIZZ 
BUZZ 
  56 
FIZZ 
  58 
  59 
FIZZBUZZ 
  61 
  62 
FIZZ 
  64 
BUZZ 
FIZZ 
  67 
  68 
FIZZ 
BUZZ 
  71 
FIZZ 
  73 
  74 
FIZZBUZZ 
  76 
  77 
FIZZ 
  79 
BUZZ 
FIZZ 
  82 
  83 
FIZZ 
BUZZ 
  86 
FIZZ 
  88 
  89 
FIZZBUZZ 
  91 
  92 
FIZZ 
  94 
BUZZ 
FIZZ 
  97 
  98 
FIZZ 
BUZZ 
```
