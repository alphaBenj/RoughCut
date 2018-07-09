/ json.q

t:([]time:asc 10?.z.t;sym:10?`AAPL`GOOG;price:10?100.0;size:10?10000)

/ save t.json
save `:t.json   

/ read in t
t:.j.k each read0 `:t.json
/or load `:t.json

/ finally update the datatypes
update "T"$time,"S"$sym,"j"$size from `t
