---
layout: post
title: Prime testing function in R
date: 2011-08-20 20:04:25.000000000 -04:00
type: post
published: true
status: publish
categories:
- R
tags:
- Math
- Primes
- R
author: wrathematics
---


I was hoping to begin tinkering a bit with the multicore package in R
beyond some extremely trivial examples. Thanks to a combination of R's
dumb quirkiness (for example, being worthless on loops), my poor
planning, and general bad programming, my Saturday afternoon tinkering
project is ultimately worthless in fulfilling that purpose.

I was really hoping to take the prime searcher I had been using to solve
Project Euler problems and use it to make a prime testing function which
would utilize the 4 cores on my adorable little core i5. I succeeded in
creating it, but it wasn't until I had finished (which thankfully was
only about an hour of time wasted) that I realized that my plan was
stupid and I was going to have to loop over entries (or use sapply(),
which is the same thing; don't kid yourself). This, as we all know, is
where R is fantastically bad.

A very hasty test showed that relying on a single core, the original way
I was doing things is a little over 2 times faster than this new
implementation. This doesn't bode well for the possible speedup when
scaling up to 4 cores, and since I have more pressing projects at the
moment, I'm going to have to dump this one barring some illumination.

However, it is a workable prime tester. And for testing against single
primes, it's honestly not *that* slow. But, as pointed out above, if
you're using it to test primality of a (reasonably large) range of
(reasonably large) values, then you're going to have to loop and R is
going to catch fire in the process.

The syntax is simple enough; simply conjure your integer of choice
\$latex n\$ and ask R

IsPrime(\$latex n\$)

which is like the old Maple syntax back when I used it extensively
(which was \~ Maple 8 or 9, I believe). Functions and sample output
below:

```R
IsPrime <- function(n){ # n=Integer you want to know if is/not
prime
if ((n-floor(n)) > 0){
cat(sprintf("Error: function only accepts natural number inputs
"))
} else if (n < 1){
cat(sprintf("Error: function only accepts natural number inputs
"))
} else
# Prime list exists
if (try(is.vector(primes), silent=TRUE) == TRUE){

# Prime list is already big enough
if (n %in% primes){
TRUE
} else
if (n < tail(primes,1)){
FALSE
} else
if (n <= (tail(primes,1))^2){
flag <- 0
for (prime in primes){
if (n%%prime == 0){
flag <- 1
break
}
}

if (flag == 0){
TRUE
}
else {
FALSE
}
}

# Prime list is too small; get more primes
else {
last.known <- tail(primes,1)
while ((last.known)^2 < n){
assign("primes", c(primes,GetNextPrime(primes)), envir=.GlobalEnv)
last.known <- tail(primes,1)
}
IsPrime(n)
}
} else {
# Prime list does not exist
assign("primes", PrimesBelow(n,below.sqrt=TRUE), envir=.GlobalEnv)
IsPrime(n)
}
}

# Get next prime
GetNextPrime <- function(primes){ # primes=Known prime list
i <- tail(primes,1)
while (TRUE){
flag <- 0
i <- i+2
if (i%%6 == 3){
flag <- 1
}
if (flag == 0){
s <- sqrt(i)+1
possible.primes <- primes[primes<s]
for (prime in possible.primes){
if ((i%%prime == 0)){
flag <- 1
break
}
}
if (flag == 0){
break
}
}
}
i
}

# Primes below specified integer n; optionally only those below
sqrt(n)
PrimesBelow <- function(n, below.sqrt=FALSE){
if (below.sqrt == TRUE){
m <- ceiling(sqrt(n))
} else {
m <- n
}

primes <- c(2,3)
i <- 3
while (i < m-1){
flag <- 0
i <- i+2
if (i%%6 == 3){
flag <- 1
}
if (flag == 0){
s <- sqrt(i)+1
possible.primes <- primes[primes<s]
for (prime in possible.primes){
if ((i%%prime == 0)){
flag <- 1
break
}
}
if (flag == 0){
primes <- c(primes, i)
}
}
}
primes
}
```

Some sample output:

```R > primes
Error: object 'primes' not found
> IsPrime(100)
[1] FALSE
> IsPrime(101)
[1] TRUE
> primes
[1] 2 3 5 7 11
>
```

After screwing around with the prime tester for a few minutes, I was
able to find this adorable little gem

```R
1> IsPrime(1234567891)
[1] TRUE
```
So 1234567891 is prime, but none of 1, 12, 123, 1234, 12345, 123456,
1234567, 12345678, 123456789, 12345678910, 123456789101, or
1234567891011 are (of course, nearly half of those are even, but the
point stands).
