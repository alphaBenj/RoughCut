This feed matches the tickerplant in tutorial Startingkdb+.

1. if necessary compile the feed (the distributed feed is for linux64):

 - get k.h from http://kx.com/q/c/c
 - get c.o from the appropriate directory under http://kx.com/q
   e.g. from http://kx.com/q/l64
 - run make

2. start a q session and load the demo:

q)\l 7.API/C/demo.q

3. check that trade is defined and empty:

q)trade
time sym price size stop cond ex
--------------------------------

4. start the feed (runs for about a minute)

5. check values in trade:

q)trade
time         sym  price  size stop cond ex
------------------------------------------
09:13:05.809 MSFT 107.77 1015 1    G    O
09:13:05.809 BML  106.49 521  0    P    O
09:13:05.809 SUN  107.63 1026 0         O
09:13:05.809 BML  102.11 468  1    T    O
...
