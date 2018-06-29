#!/usr/bin/python
"""
From IEX's native api , this module will allow you to  :
- get latest quote and trade data
- get trade data only
Started with Himanshu Gupta's IEX_Data github repo. 
Examples:
        iex = API()
        print(iex.latestTrade(['AAPL', 'IBM']))
        print(iex.latestQuoteTrade_data(['AAPL', 'IBM']))
"""
import pandas as pd
from pandas.io.json import json_normalize
import requests, io, json

class API(object):
    
    def __init__(self):
        self._IEX_URL_PREFIX = r'https://api.iextrading.com/1.0/'

    def secUpper(self, securities):
        return [x.upper() for x in securities]

    def _GetDataFrame(self, url, nest=None):
        """
        Takes a url and returns the response in a pandas dataframe
        :param url: str url
        :param nest: column with nested data
        :return: pandas dataframe containing data from url
        """
        urlData     = requests.get(url).content.decode('utf-8')
        rawData     = json.loads(urlData)
        
        if nest:    rawData = json_normalize(rawData[nest])
        else:       rawData = json_normalize(rawData)
        return pd.DataFrame(rawData)

    def tradeBars(self, securities, bucket='1m'):
        """
        Get bucketed trade/volume data. Supported buckets are: 1m, 3m, 6m, 1y, ytd, 2y, 5y
        :param securities: list of securities
        :param bucket:
        :return: dataframe
        """
        cols        = ['symbol','date','open','high','low','close','volume', 'AdjClose']
        colsDaily   = ['symbol','date','minute','open','high','low','close','volume', 'marketOpen','marketHigh', 'marketLow','marketClose', 'marketVolume', 'average', 'marketAverage','label',]
        filters     = "&filter=symbol,date,time,open,high,low,close,volume"#,changePercent,vwap"   
        if bucket == "1d":    
            cols        = colsDaily
            filters     = ""
      
        syms        = (',').join(self.secUpper(securities))
        suffix      = r"stock/market/batch?types=time-series&range={bucket}&symbols={symbol}".format(bucket=bucket,symbol=syms)
        urlData     = requests.get(self._IEX_URL_PREFIX + suffix+filters).content.decode('utf-8')
        rawData     = json.loads(urlData)
      
        df          = pd.DataFrame()     
        for sym, v in rawData.items():
            [e.update({'symbol':sym}) for e in v['time-series']]    
            _df             = pd.DataFrame(v['time-series'])
            _df["date"]     = _df["date"].str.replace("-","")
            _df["AdjClose"] = _df["close"]
            df              = pd.concat([df,_df])  
        return df[cols]

    def lastTrade(self, securities):
        """
        Gets latest trade data
        :param securities: list of securities
        :return: pandas dataframe containing data for valid securities
        """
        symbols         = (',').join(self.secUpper(securities))
        suffix          = r'tops/last?symbols='
        df              = self._GetDataFrame(self._IEX_URL_PREFIX + suffix + symbols)
        df['time']      = pd.to_datetime(df['time'], unit='ms').dt.time
        df.set_index(['symbol'], inplace=True)
        return df
  
    def lastTradeQuote(self, securities):
        """
        Gets latest quote and trade data
        :param securities: list of securities
        :return: pandas dataframe containing data for valid securities
        """
        cols                = [ 'lastSaleTime','askSize','askPrice','lastSalePrice', 'bidPrice', 'bidSize','lastSaleSize','lastUpdated', 'volume']
        filters             = ""
        
        symbols             = (',').join(self.secUpper(securities))
        suffix              = r'tops?symbols='
        df                  = self._GetDataFrame(self._IEX_URL_PREFIX + suffix + symbols)
        df['lastSaleTime']  = pd.to_datetime(df['lastSaleTime'], unit='ms').dt.time
        df['lastUpdated']   = pd.to_datetime(df['lastUpdated'], unit='ms').dt.time
        df.set_index(['symbol'], inplace=True)
        return df[cols]
  
    def infoCompEarns(self, securities):
        """
        Get latest earnings for securities.
        :param securities: list of symbols
        :return: dataframe
        """
        cols    = ['symbol','EPSReportDate', 'announceTime', 'actualEPS', 'consensusEPS','estimatedEPS','EPSSurpriseDollar',  'fiscalEndDate', 'fiscalPeriod', 'numberOfEstimates', ] 
        filters = ""
        
        df      = pd.DataFrame({})
        for symbol in self.secUpper(securities):
            suffix          = r'stock/{symbol}/earnings'.format(symbol=symbol)
            _df             = self._GetDataFrame(self._IEX_URL_PREFIX + suffix+filters, 'earnings')
            _df['symbol']   = symbol
            df              = pd.concat([df,_df])
        return df[cols]

    def infoCompNews(self, securities, count=1):
        """
        Get latest news for securities. By default, gets one news item per security.

        :param securities: list of securities
        :param count: how many news items to return
        :return: dataframe
        """
        df      = pd.DataFrame({})
        cols    = ['symbol', 'time', 'headline', 'summary', 'source', 'url','related']
        filters = ""
        for sym in self.secUpper(securities):
            suffix          = r'stock/{symbol}/news/last/{count}'.format(symbol=sym, count=count)
            _df             = self._GetDataFrame(self._IEX_URL_PREFIX + suffix)
            _df['time']     = pd.to_datetime(_df['datetime']).dt.time
            _df['symbol']   = sym
            df              = pd.concat([df,_df])
        return df[cols]


    def infoCompFins(self, securities):
        """
        Get latest financials of securities. By default, gets one news item per security.
        :param securities: list of symbols
        :return: dataframe
        """
        df      = pd.DataFrame({})
        # Get financials of each security and then append the results together
        filters = ""
        for symbol in self.secUpper(securities):
                suffix          = r'stock/{symbol}/financials'.format(symbol=symbol)
                _df             = self._GetDataFrame(self._IEX_URL_PREFIX + suffix, 'financials')
                _df['symbol']   = symbol
                df              = pd.concat([df,_df])
        return df

 

   # def return_valid_securities(self, securities):
    #     """
    #     Return a list of valid securities
    #     :param securities: list of securities
    #     :return: list of valid securities
    #     """
    #     suffix           = r'ref-data/symbols'
    #     valid_securities = self._GetDataFrame(self._IEX_URL_PREFIX+suffix)['symbol']
    #     return [x for x in securities if x in set(valid_securities)]


