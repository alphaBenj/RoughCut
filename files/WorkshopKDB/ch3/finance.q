\l 3.historical/buildtaq.q

/ this changes directory to db/taq and loads the database
\l db/taq

/ joins ----------------------------------------------------
t:select time,price from trade where date=last date,sym=`IBM

q:select time,bid,ask from quote where date=last date,sym=`IBM

aj[`time;t;q]

aj[`time;q;t]
