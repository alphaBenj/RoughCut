
\l db/taq

\a
trade
quote
daily

sym
mas

select price%size from daily
   where date in -5 sublist distinct date,sym=`IBM

select (sum price)%sum size from daily
   where date in -5 sublist distinct date,sym=`IBM

count trade
count quote
select count i by date from trade
select from trade where date=last date, sym=`AMD

select time,price from trade where date=last date, sym=`AMD
