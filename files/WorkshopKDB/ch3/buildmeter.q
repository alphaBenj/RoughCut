nd:50; 		/ number of dates
db:`:db/meter 	/ default db directory
g:30;		/ number of gas symbols
e:50;		/ appox number of electricity symbols


n:count s:`1903`1548 union`$string 1000+(neg g)?1500;
m:count t:s union `$string 1000+(neg e-g)?1500;

use:{raze {[n]$[rand 2;n#0f;n?5.0f]}each -9?x,48-sum x:4+8?2}
walk:{delta:-1+rand 2f;(0.1*floor 10*)$[(signum delta)~signum x;$[(rand 1f)<exp neg abs x*delta*.000005;delta+x;x-delta];delta+x]}

run:{
 `gas set ([]id:raze 48#'s;time:(n*48)#00:30:00*1+til 48;usage:raze use each n#`);
 `electricity set ([]id:raze 48#'t;time:(m*48)#00:30:00*1+til 48;usage:(m*48)?5.0);
 }

d:.z.d;
do[nd;
 run[];
 .Q.dpft[db;d;`id;]each `gas`electricity;
 d-:1;
 ]; 
d+:1;

(` sv db,`weather) set ([]datetime:d+"n"$3600e9*til 24*nd;temp:85+1_walk\[24*nd;-10f]);

/exit 0;

