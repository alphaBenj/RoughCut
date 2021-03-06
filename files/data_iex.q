/
#########################################################################################
# Author : Asher  Benjamin															
# Description: IEX API.  This code is a q/kdb+ wrapper to make it easier	
#  modiyfing Himanshu Guptas git repo. 
# IEX api URL: https://iextrading.com/developer/docs/#getting-started					
#########################################################################################
\

urlRoot: "api.iextrading.com";
prefix: "HTTP/1.0\r\nhost:www.",urlRoot,"\r\n\r\n";

/ Function for converting epoch time
resetTime:{"p"$1970.01.01D+1000000j*x};
 
/ Function for issuing GET request and getting the data in json format
getData:{[urlRoot;suffix;prefix;char_delta;identifier]
  result: (`$":https://",urlRoot) suffix," ",prefix;
  (char_delta + first result ss identifier) _ result
 }
 
/ get last trade data for one or multiple securities
/ q)lastTrade`aapl`ibm
/ sym  price  size time
/ ----------------------------------------------
/ AAPL 174.66 100  2017.11.10D20:59:58.008999936
/ IBM  149.18 300  2017.11.10D20:59:59.724999936  

lastTrade:{[syms] 

  / This function can run for multiple securities.
  syms:$[1<count syms;"," sv string(upper syms);string(upper syms)];
  suffix: "GET /1.0/tops/last?symbols=",syms;
  data:.j.k getData[urlRoot;suffix;prefix;-3;"symbol"];

  `sym xcol update symbol:`$symbol, time:"P"$string(resetTime time) from data
 }
 
/ Get previous day summary for a security - high, low, open, close, vwap etc
/ q)summaryPDO`aapl

summaryPDO:{[sym]

  sym:string(upper sym);
  suffix: "GET /1.0/stock/",sym,"/previous";
  data: enlist .j.k getData[urlRoot;suffix;prefix;-2;"symbol"];
  
  `sym xcol update symbol:`$symbol, date:"D"$date from data
 }

/ Get bucketed data for a security for different periods 
/ Available buckets are:
/ 	1d - 1 day
/   1m - 1 month
/   3m - 3 months
/   6m - 6 months
/   ytd - Year-to-date
/   1y - 1 year
/   2y - 2 years
/   5y - 5 years
/ q)get_historical_summary[`aapl;`1m] 

tradeBars:{[sym;period]

  sym:string(upper sym);
  period:string(period);
  suffix: "GET /1.0/stock/",sym,"/chart/",period;
  
  / Remove any text from response before 'minute' if period is 1d and 'date' otherwise
  txt:$[all "1d"=period;"minute";"date"];
  
  data:.j.k "[", getData[urlRoot;suffix;prefix;-2;txt];
  
  / data has different schema for 1d vs other buckets
  $[all "1d"=period;
  `sym`minute xcols update sym:`$sym,minute:"U"$minute from data;
  `sym`date xcols update sym:`$sym, date:"D"$date from data]
 }

/ Same as get_historical_summary but for a specific date
/ q)tradeBarsMin[`aapl;`20171103] 

tradeBarsMin:{[sym;date]

  sym:string(upper sym);
  date:string(date);
  suffix: "GET /1.0/stock/",sym,"/chart/date/",date; 
  data:.j.k "[",getData[urlRoot;suffix;prefix;-2;"minute"];
  
  `sym`date`minute xcols update sym:`$sym, date:"D"$date, minute:"U"$minute from data
 }

/ Get information about a company such as exchange, industry, website, description, CEO etc
/ q)get_company_info`aapl 

infoCompSummary:{[sym]

  sym:string(upper sym);
  suffix: "GET /1.0/stock/",sym,"/company";
  data: enlist .j.k getData[urlRoot;suffix;prefix;-2;"symbol"];
  
  / Rename symbol to sym
  `sym xcol update symbol:`$symbol from data
 }

/ Get key stats about a company such as market cap, beta, revenue, debt etc
/ q)get_key_stats`aapl
 
infoKeyStats:{[sym]

  sym:string(upper sym);  
  suffix: "GET /1.0/stock/",sym,"/stats";
  data: enlist .j.k getData[urlRoot;suffix;prefix;-2;"companyName"];
  
  / Update data types and rename symbol column to sym
  `sym xcol `symbol xcols update latestEPSDate:"D"$latestEPSDate, shortDate:"D"$shortDate, exDividendDate:"D"$exDividendDate, symbol:`$symbol from data
 }

/ Get news relating to a company
/ q)get_company_news`aapl

infoCompNews:{[sym]

  sym:string(upper sym);
  suffix: "GET /1.0/stock/",sym,"/news";
  data:.j.k "[",getData[urlRoot;suffix;prefix;-2;"datetime"];

  `sym xcols update sym:`$sym, datetime:"P"$datetime from data
 }
 
/ Get financial information of a company such as report date, gross profit, net income etc
/ q)get_company_financials`aapl

infoCompFins:{[sym]

  sym:string(upper sym);
  suffix: "GET /1.0/stock/",sym,"/financials";
  data:.j.k getData[urlRoot;suffix;prefix;-2;"symbol"];
  
  `sym xcols update sym:`$sym, reportDate:"D"$reportDate from data[`financials]
 }
 
/ Get earnings information of a company such as actual EPS, consensus EPS, estimated EPS etc
/ q)get_company_earnings`aapl

infoCompEarns:{[sym]

  sym:string(upper sym);
  suffix: "GET /1.0/stock/",sym,"/earnings";
  data:.j.k getData[urlRoot;suffix;prefix;-2;"symbol"];
  
  `sym xcols update sym:`$sym, EPSReportDate:"D"$EPSReportDate, fiscalEndDate:"D"$fiscalEndDate from data[`earnings]
 }

/ Get most 'active' stocks for last trade date with additional info such as close price, open price etc
/ q)get_most_active_stocks[]

stocksActive:{
   iexListsData[`mostactive]
 }

/ Get stocks with highest gains for last trade date with additional info such as close price, open price etc
/ q)get_most_gainers_stocks[] 

stocksUps:{
  iexListsData[`gainers]
 }

/ Get stocks with most loss for last trade date with additional info such as close price, open price etc
/ q)get_most_losers_stocks[] 

stocksDowns:{iexListsData[`losers]}

/ Helper function for getting 'lists' data from IEX
/ There are three types of lists: most active, gainers and losers 
iexListsData:{[list]
 
  list: string(list);
  suffix: "GET /1.0/stock/market/list/",list;
  data:.j.k "[",getData[urlRoot;suffix;prefix;-2;"symbol"];
  
  `sym xcol update symbol:`$symbol, openTime:"P"$string(resetTime openTime), closeTime:"P"$string(resetTime closeTime), latestUpdate:"P"$string(resetTime latestUpdate), iexLastUpdated:"P"$string(resetTime iexLastUpdated), delayedPriceTime:"P"$string(resetTime delayedPriceTime) from data
 }