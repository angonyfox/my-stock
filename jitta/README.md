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
q)input: select r, symbol, jittaPrice: price  from 5#loadRes `rank_20180628_1.json`rank_20180628_2.json
r symbol jittaPrice
-------------------
1 TCAP   48.25
2 TISCO  85.5
3 LALIN  5.75
4 TMW    65.5
5 SPALI  24.2

q)fqs: .set.fq each exec symbol from input
q)res: input ,'extractPrices fqs
r symbol jittaPrice last  close bid   bidQty ask   askQty ask2  askQty2
-----------------------------------------------------------------------
1 TCAP   48.25      46.5  46.75 46.25 83200  46.5  82800  46.75 156800
2 TISCO  85.5       83.75 84    83.75 9000   84    38600  84.25 2300
3 LALIN  5.75       5.4   5.4   5.4   60200  5.45  14700  5.5   8100
4 TMW    65.5       64    64.75 64    2500   64.25 2000   64.5  4000
5 SPALI  24.2       23.6  23.5  23.6  7300   23.7  27900  23.8  24000

q)port: calcRatio calcInvest select from calcQty update price: ask, allocation: 1e5 from res
r symbol jittaPrice last  close bid   bidQty ask   askQty ask2  askQty2 price allocation qty   investAmount remainAmount investRatio
------------------------------------------------------------------------------------------------------------------------------------
1 TCAP   48.25      46.5  46.75 46.25 83200  46.5  82800  46.75 156800  46.5  100000     2100  97650        2350         20.1
2 TISCO  85.5       83.75 84    83.75 9000   84    38600  84.25 2300    84    100000     1100  92400        7600         19.02
3 LALIN  5.75       5.4   5.4   5.4   60200  5.45  14700  5.5   8100    5.45  100000     18300 99735        265          20.53
4 TMW    65.5       64    64.75 64    2500   64.25 2000   64.5  4000    64.25 100000     1500  96375        3625         19.84
5 SPALI  24.2       23.6  23.5  23.6  7300   23.7  27900  23.8  24000   23.7  100000     4200  99540        460          20.49

q)calcSummary port
allocation investAmount remain
------------------------------
500000     485700       14300

q)calcLiquidity port
r symbol jittaPrice last  close bid   bidQty ask   askQty ask2  askQty2 price allocation qty   investAmount remainAmount investRatio liquidity
----------------------------------------------------------------------------------------------------------------------------------------------
1 TCAP   48.25      46.5  46.75 46.25 83200  46.5  82800  46.75 156800  46.5  100000     2100  97650        2350         20.1        237500
2 TISCO  85.5       83.75 84    83.75 9000   84    38600  84.25 2300    84    100000     1100  92400        7600         19.02       39800
3 LALIN  5.75       5.4   5.4   5.4   60200  5.45  14700  5.5   8100    5.45  100000     18300 99735        265          20.53       4500
4 TMW    65.5       64    64.75 64    2500   64.25 2000   64.5  4000    64.25 100000     1500  96375        3625         19.84       4500
5 SPALI  24.2       23.6  23.5  23.6  7300   23.7  27900  23.8  24000   23.7  100000     4200  99540        460          20.49       47700

q)adjPort: adjustInvestment port
r symbol jittaPrice last  close bid   bidQty ask   askQty ask2  askQty2 price allocation qty   investAmount remainAmount investRatio
------------------------------------------------------------------------------------------------------------------------------------
1 TCAP   48.25      46.5  46.75 46.25 83200  46.5  82800  46.75 156800  46.5  100000     2100  97650        2350         19.76
2 TISCO  85.5       83.75 84    83.75 9000   84    38600  84.25 2300    84    100000     1200  100800       -800         20.4
3 LALIN  5.75       5.4   5.4   5.4   60200  5.45  14700  5.5   8100    5.45  100000     18300 99735        265          20.18
4 TMW    65.5       64    64.75 64    2500   64.25 2000   64.5  4000    64.25 100000     1500  96375        3625         19.5
5 SPALI  24.2       23.6  23.5  23.6  7300   23.7  27900  23.8  24000   23.7  100000     4200  99540        460          20.14

q)calcSummary adjPort
allocation investAmount remain
------------------------------
500000     494100       5900
```
optionally place orders and tracks live order status
```
q)orders: select side: `B, sym: symbol, qty, price from adjPort
side sym    qty   price
-----------------------
B    TCAP   2000  48
B    TISCO  1200  85
B    LALIN  17200 5.8
B    TMW    1500  66
B    SPALI  4100  24.1
q)executions: .set.placeBulkOrder orders
```