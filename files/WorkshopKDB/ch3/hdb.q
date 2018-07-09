
/ this changes directory to db/taq and loads the database
\l db/taq

/ run this only once in a session - try again and it gives
/ a directory error (since it has already changed directory):
/ 'db/taq: Is a directory

/ vwap ----------------------------------------------------
2 3 7 wavg 10 20 30
select size wavg price by sym from trade

t:select from trade where date=last date,sym=`IBM
count t

select size wavg price from t

select size wavg price by time.minute from t

select size wavg price by 5 xbar time.minute from t

select lprice:last price,wprice:size wavg price
 by 15 xbar time.minute from t

select lprice:last price,wprice:size wavg price
  by 15 xbar time.minute from t

/ correlation ---------------------------------------------
daily

t:exec close by get sym from daily

t`HPQ
(t`HPQ) cor t`ORCL

c:t cor/:\: t

c`HPQ
desc c`HPQ

/ joins ----------------------------------------------------
t:select time,price from trade where date=last date,sym=`IBM

q:select time,bid,ask from quote where date=last date,sym=`IBM

aj[`time;t;q]

aj[`time;q;t]
