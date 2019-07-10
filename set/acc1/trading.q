system "../linux/login_tisco.sh"
system "../linux/login_set.sh"
/\l ../../jitta/jitta.q

\l ../q/set.q
/2019/07/08
/jitta_dir: "../../jitta/"
/ranking: loadRes hsym `$jitta_dir,/: ("rank_20180628_1.json"; "rank_20180628_2.json")
/top30: 30#ranking
/s: exec symbol from `symbol xasc top30

s: `AEONTS`AP`ASIMAR`ASK`ASP`BAY`BKI`FNS`FORTH`FSMART`KGI`LALIN`LIT`PT`PTTGC`S11`SAPPE`SF`SIS`SMK`SPALI`STANLY`SWC`TCAP`THANI`TIP`TISCO`TMW`UTP`VNT
q: 600 11400 35400 4500 26500 2500 300 22400 14800 10600 25700 17200 12900 15100 1300 13500 3800 14040 11700 2400 4100 400 8800 2000 17250 4400 1200 1500 8800 3800
o: ([] sym: s; sellingQty: q)

.set.int.portfolio: {0N!raze system "../linux/portfolio.sh"}
pf: .set.portfolio[]

/check selling qty against position
o: update remainingQty: pos - sellingQty from o lj select pos: last qty by sym from pf

.set.int.fastquote: {raze system "../linux/fastquote.sh ", string x}
.set.int.orderStatus: {0N!raze system "../linux/orderstatus.sh"}
.set.int.cancelOrder: {[sym; orderid] 0N!raze system "../linux/cancelorder.sh ", (string sym), " ", (string orderid)}
.set.int.placeOrder: {[side; sym; qty; price] 0N!raze system "../linux/placeorder.sh ", (string side), " ", (string sym), " ", (string qty), " ", (string price)}

/test run
.set.placeOrder[`B; `SVI; 100; 3.5] /set some price far from the market
.set.orderStatus[]
.set.cancelOrder[`SVI; `1WSYPH1Y81]

.set.placeBulkOrder
/orders: select side: `B, sym: symbol, qty, price from adjPort

/check quotes
parseQuotesL1: {{((enlist `sym)!(enlist `$x`symbol)), first .set.int.parseBov x} each x}
quotes: .set.fq each exec sym from o
o: o lj 1!parseQuotesL1 quotes

orders: select side: `S, sym, qty: sellingQty, price: ask from o where sym in `SF`THANI
orders: flip (`side`sym`qty`price)!flip ((`S; `SF; 14000; 6.5); (`S; `THANI; 17200; 7))
.set.placeBulkOrder orders
st: .set.orderStatus[]
o lj select sum fillQty, sum liveQty by sym from st

checkLiveExecution: {
  st: .set.orderStatus[];
  queing: select from st where status=`Queuing;
  quotes: .set.fq each exec sym from queing;
  update bidPremium: bid - price, askPremium: ask - price from queing lj 1!parseQuotesL1 quotes}

t: checkLiveExecution[]
/aggress order to offer level
{.set.cancelOrder[x`sym; x`orderid]; .set.placeOrder[`S; x`sym; x`liveQty; x`ask]} each select from t where askPremium<0

