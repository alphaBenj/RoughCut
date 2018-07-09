
/
Technical Trading Rules
install.packages("TTR")
\l rfns.q
\

\l db/taq

Rget "3:7"

/ example using BBands (Bollinger Bands) the from TTR (Technical Trading Rules) package

Rcmd "library('TTR')"

/ usually this would be applied to daily data, but we will use the
/ prices for a single day, since there are more values in the database:

t:exec price from select from trade where date=last date,sym=`IBM
count t
Rset["price";t]
count Rget "price"
t~Rget "price"
r:Rget "BBands(price,20)"
r 0                / header information
r 1                / data results
19 _ r 1           / ignore first 19 results
