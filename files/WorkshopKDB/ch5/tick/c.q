/todo: recovery .u.rep
/ q tick/c.q {last|..} [host]:port[:usr:pwd]
/ realtime alerts and continuous queries

x:.z.x,count[.z.x]_("last";":5010")
h:hopen`$":",x 1;x@:0

t:`;s:`	

/ last
if[x~"last";upd:{[t;x].[t;();,;select by sym from x]}]

/ all trades with then current quote
if[x~"tq";
 upd:{[t;x]$[t~`trade;tq,:x lj .u.q;.u.q,:select by sym from x]}]

/ vwap for each sym
if[x~"vwap";t:`trade;
 upd:{[t;x]vwap+:select size wsum price,sum size by sym from x;update vwap:price%size from `vwap}]

/ high low close volume
if[x~"hlcv";t:`trade;hlcv:([sym:()]high:();low:();price:();size:());
 upd:{[t;x]hlcv::select max high,min low,last price,sum size by sym 
    from(0!hlcv),select sym,high:price,low:price,price,size from x}]


/ subscribe and initialize
$[`~t;(upd .)each;(upd .)]h(".u.sub";t;s);

.u.end:{@[`.;tables`.;0#];}
