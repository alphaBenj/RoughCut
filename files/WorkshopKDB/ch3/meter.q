\l 3.Historical/buildmeter.q

/ this changes directory to db/meter and loads the database
\l db/meter

/ run this only once in a session - try again and it gives
/ a directory error (since it has already changed directory):
/ 'db/meter: Is a directory

count electricity
count gas

select count i by date from electricity

select from electricity where date=last date, id=`1903

/ avg  ----------------------------------------------------------------
avg 1 4 6
select avg usage by id from gas

select avg usage by time from gas where date=last date, id=`1903

select time, usage from gas where date=last date, id=`1903

t:select avg usage by time from gas where date within 2015.05.17 2015.05.27, id=`1903

select time from t where usage=max usage

t2:select avg usage by time,id from gas where date within 2015.05.17 2015.05.27

select average:avg usage, deviation:dev usage, high:max usage,low:min usage by time from t2

/ correlation --------------------------------------------------------
daily:select sum usage by date,id from gas

t:exec usage by get id from daily

t`1903

(t`1903) cor t`1548

c:t cor/:\: t

c`1903

desc c`1903

w:exec temp from (select avg temp by datetime.date from weather)
w cor t`1903

/ rank ---------------------------------------------------------------
rank 2 7 3 2 5

t:select sum usage by id, time:time.hh from electricity where date=last date

t:ungroup select id,usage,position:rank neg usage by time from t

select from t where position=0

\l 3.Historical/time.q
