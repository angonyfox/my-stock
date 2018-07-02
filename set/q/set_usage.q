/runs this in command line before starting Q
/set\win\setenv.bat
/set\win\login.bat

\l set/q/set.q

pf: .set.portfolio[]
st: .set.orderStatus[]

.set.ticker `BANPU
.set.bov `BANPU
.set.last `BANPU
.set.close `BANPU

.set.index[]

/id: .set.placeOrder[`B; `BANPU; 100; 15]
/.set.cancelOrder[`BANPU; `$id]
/.set.placeBulkOrder ([]side: `B`S; sym: `BANPU`SYMC; qty: (10; 20); price: (100f; 120f))
/.set.cancelAllStatus[.set.orderStatus[]; `Queuing]
