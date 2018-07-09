/ feed demo

\p 5010

trade:flip `time`sym`price`size`stop`cond`ex!()

upd:{[t;x]
 n:count x 0;          / new record count
 r:(enlist n#.z.T),x;  / add timestamp
 t insert r}           / insert into table
