/ csv.q

\l db/taq

/ in Windows:
/ save daily
save `:c:/temp/daily.csv

/ read in daily
tab:("DSFFFFFI";enlist ",") 0: `:c:/temp/daily.csv

/ in Linux:
save `:/home/chris/daily.csv
tab:("DSFFFFFI";enlist ",") 0: `:/home/chris/daily.csv
