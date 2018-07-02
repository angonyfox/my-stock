# jitta scripts
parse data from jitta ranking json obtained from https://www.jitta.com/explore

## How to get json data

1. go to https://www.jitta.com/explore?country%5B0%5D=TH
2. open Network dev tool
3. copy json response from link that looks like https://instantsearch.jitta.com/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%20(lite)%203.24.8%3Breact-instantsearch%204.1.3%3BJS%20Helper%202.23.2&x-algolia-application-id=L6HU33HKS0&x-algolia-api-key=8fa6652dfc7f2225015b6d6613466a82

## jitta.q
reads and parse jitta json response in ./jitta/*
starts q at root `./q -p 6666`
```q
\l jitta/jitta.q
loadRes `response.json`response2.json
```
result
```
r  market exchange symbol sector                 industry                                              company_name                                           price price_updated_at        jitta_score updatedAt               price_diff loss_chance j_rank_score last_complete_statement_enddate last_complete_statement_key updated_at
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1  TH     BKK      TCAP   Financials             Banks                                                 Thanachart Capital Public Company Limited              48.25 2018.06.27T00:00:00.000 8.13        2018.06.27T11:26:15.875 -60.52     38.47       6067.364     2018-03-31                      2018-1                      2018.06.27T11:34:31.674
2  TH     BKK      TISCO  Financials             Banks                                                 TISCO Financial Group Public Company Limited           85.5  2018.06.27T00:00:00.000 8.32        2018.06.27T11:24:11.777 -0.4045    36.55       4436.508     2018-03-31                      2018-1                      2018.06.27T11:34:27.888
3  TH     BKK      LALIN  Real Estate            Real Estate Management and Development                Lalin Property Public Company Limited                  5.75  2018.06.27T00:00:00.000 6.97        2018.06.27T11:23:58.222 -91.38     37.05       4131.168     2018-03-31                      2018-1                      2018.06.27T11:34:37.595
4  TH     BKK      TMW    Materials              Chemicals                                             Thai Mitsuwa Public Company Limited                    65.5  2018.06.27T00:00:00.000 6.2         2018.06.27T11:25:47.074 -134.4     37.05       4032.164     2018-03-31                      2018-4                      2018.06.27T11:34:24.188
5  TH     BKK      SPALI  Real Estate            Real Estate Management and Development                Supalai Public Company Limited                         24.2  2018.06.27T00:00:00.000 6.8         2018.06.27T11:24:12.352 -61.75     37.05       3926.47      2018-03-31                      2018-1                      2018.06.27T11:34:34.930
```

## jitta_execute.q
load live prices/order book and calculates order qty for given allocations
```
r  symbol jittaPrice last  close bid   bidQty ask   askQty ask2  askQty2 price allocation qty   investAmount remainAmount investRatio
-------------------------------------------------------------------------------------------------------------------------------------
1  TCAP   48.25      47.75 48.25 47.75 140200 48    130000 48.25 192200  48    100000     2000  96000        4000         3.2
2  TISCO  85.5       84.75 85.5  84.75 20900  85    120000 85.25 104100  85    100000     1200  102000       -2000        3.4
3  LALIN  5.75       5.8   5.75  5.7   50500  5.8   15100  5.85  29600   5.8   100000     17200 99760        240          3.32
4  TMW    65.5       0     65.5  65.5  8400   66    800    66.25 500     66    100000     1500  99000        1000         3.3
5  SPALI  24.2       24.1  24.2  24    119100 24.1  89900  24.2  47300   24.1  100000     4100  98810        1190         3.29
```
optionally place orders and tracks live order status
```
side sym    qty   price
-----------------------
B    TCAP   2000  48
B    TISCO  1200  85
B    LALIN  17200 5.8
B    TMW    1500  66
B    SPALI  4100  24.1
```