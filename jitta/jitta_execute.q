/runs this in command line before starting Q
/set\win\setenv.bat

\l set/q/set.q
\l jitta/jitta.q

calcQty: {update qty: 100 * floor qty%100 from update qty: floor allocation%price from x}
calcInvest: {update remainAmount: allocation - investAmount from update investAmount: qty * price from x}
calcRatio: {update investRatio: 0.01 * floor 10000 * investAmount%(sum investAmount) from x}
calcSummary: {update remain: allocation - investAmount from select sum allocation, sum investAmount from x}
calcLiquidity: {update liquidity:(askQty + askQty2)-qty from x}

/add qty until no remaining amount
adjustInvestment: {
  xx: calcRatio calcInvest update qty + 100 from x where investRatio=min investRatio;
  $[(exec first remain from calcSummary xx) > 0; adjustInvestment[xx]; x]}

extractPrices: {(`last`close#x), exec first bid, first bidQty, first ask, first askQty, ask2: ask[1], askQty2: askQty[1] from .set.int.parseBov x}'

t: loadRes `response.json`response2.json
t2: loadRes `rank_20180628_1.json`rank_20180628_2.json
/t2: 5#t2
input: select r, symbol, jittaPrice: price  from t2
fqs: .set.fq each exec symbol from input
res: input ,'extractPrices fqs

/calculate [qty] (to be executed) from column [price] to assumed execution price, [allocation] to cash amount we want to allocate to this position
t: calcQty update price: ask, allocation: 1e5 from res
port: calcRatio calcInvest select from t where r <= 30
calcSummary port
adjPort: adjustInvestment port
calcLiquidity adjPort
calcSummary adjPort

orders: select side: `B, sym: symbol, qty, price from adjPort

/place orders
executions: .set.placeBulkOrder orders

/check order status
liveOrderStatus: {
  st: .set.orderStatus[];
  fqs: .set.fq each exec sym from select from st where not status in `Matched`Cancelled;
  (select from st where not status in `Matched`Cancelled),' extractPrices fqs}

liveOrderStatus[]
.set.portfolio[]