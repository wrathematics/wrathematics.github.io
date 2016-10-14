---
layout: post
comments: true
title: fibonacci series by goto in fortran 77
date: 2015-03-19 20:42:38.000000000 -04:00
type: post
published: true
status: publish
categories: []
tags:
- Fortran
author: wrathematics
---


Someone recently found my blog by searching for the phrase "fibonacci series by goto in fortran 77":

![fortran]({{ site.baseurl }}/assets/fortran.png)

Never let it be said that I am not a man of the people:

```fortran
      SUBROUTINE FIB(N)
      INTEGER N,I,F0,F1,TMP
      I=0
 1060 IF(N.GT.0)THEN
      GOTO6129
      ELSE
      GOTO7290
      ENDIF
 6129 WRITE(*,3502) 1
      N=N-1
      I=I+1
      IF(I.LT.2)THEN
      GOTO1060
      ELSE
      GOTO9321
      ENDIF
 9321 CONTINUE
      F0 = 1
      F1 = 1
      I = 2
 3502 FORMAT(I6)
      N=N+1
 2714 TMP = F1
      F1 = F1 + F0
      F0 = TMP
      WRITE(*,3502) F1
      IF(I.LT.N)THEN
      I = I + 1
      GOTO2714
      ENDIF
 7290 C
     $  O
     $    N
     $      T
     $      I
     $    N
     $  U
     $E
      ENDSUBROUTINE
      PROGRAM MAIN
      INTEGER N
      N=12
      CALL FIB(N)
      END
```

Compile with f77:

```
$f77 FIB.F  && ./a.out 
     1
     1
     2
     3
     5
     8
    13
    21
    34
    55
    89
   144
```
