/ generate order book data
/ one hour 10-11m, 100K records

book:([]time:`time$();sym:`$();price:`float$();size:`int$();side:`char$();ex:`$())

s:`AMD`AIG`AAPL`DELL`DOW`GOOG`HPQ`INTC`IBM`MSFT
p:84 27 33 12 20 37 18 84 39 72 / price
e:`ARCA`INET`LAVA`TRAC where 4 4 2 1
v:100*0 0,(til 11),15 20

cnt:count s
pi:acos -1
gen:{exp 0.00015 * normalrand x}
normalrand:{(cos 2 * pi * x ? 1f) * sqrt neg 2 * log x ? 1f}
randomize:{value "\\S ",string "i"$0.8*.z.p%1000000000}
rnd:{0.01*floor 0.5+x*100}

\S 235721

/ =========================================================
/ generate a batch of prices
/ qx index, qp price, qn position
batch:{
 d:gen x;
 qx::x?cnt;
 n:where each qx=/:til cnt;
 s:p*prds each d n;
 qp::x#0.0;
 (qp raze n):rnd raze s;
 p::last each s;
 qn::0}

len:1000
batch len
maxn:10

/ =========================================================
makebook:{
 o:10:00:00.000;
 d:3600000;
 len:100000;
 feed each o+asc len?d;
 book::`time xasc update price:rnd price from book;}

/ =========================================================
/ sym,time,price,size,side,ex

feed:{
 i:qx qn;p:qp qn;qn+:1;
 if[not qn<count qx;batch len];
 d:-1 1 b:0<m:0.25*normalrand 1;m:0.2+rnd m*1?1.0;
 book,:flip (x;s i;p+d*m;1?v;"BS" b;1?e);}

makebook[]

\

count book
select min price,max price by sym from book
count t:select last size by side,price,ex from book
  where sym=`AAPL,time within 10:29:30 10:30:00
count w:select sum size by side,price from t where size>0
{(count x),count distinct x} exec price from w
(5#w),-5#w