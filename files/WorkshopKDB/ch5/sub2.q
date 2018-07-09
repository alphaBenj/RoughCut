h:hopen`::5010;

upd:{
  .[`trade;();,;select by sym from y];
  .[`open;();{y,x};select by sym from y];

  o:(open each `GOOG`AAPL)`price;
  p:(trade each `AAPL`GOOG)`price;
  s:(%). o*p;
  
  show (" "sv string p,s)," ",$[s<0.98;"buy apple, sell google";s>1.02;"sell apple, buy google";"hold"];
  }

h(`.u.sub;`trade;`GOOG`AAPL)
