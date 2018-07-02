\l lib/qchart/qchart.q
-100#trade
quote

select from trade where sym=`S50H17
x:select time, sym, mid: 0.5 * bid+ask from quote where lvl=`L1
xx:select last mid by 1 xbar time.minute, sym from x
qchart.line select minute, uz:u16-z16, zh:z16-h17 from select u16:last mid where sym=`S50U16, z16: last mid where sym=`S50Z16, h17:last mid where sym=`S50H17 by minute from xx
qchart
qchart.lineSym 0!select last mid by 1 xbar time.minute, sym from x

fetchAndParsePortfolio[]

save `trade
save `quote