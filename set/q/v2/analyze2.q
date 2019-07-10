parseJson: {(delete data from x) ,' .j.k each exec data from x}
removePreOpen: {[dat] dat where not {`openopendata2 in key x} each dat}
x2: parseJson select from t where sym=`S50U19
x2: parseJson select from t where sym=`SVI
x2: removePreOpen x2

x2: ({@[x; where x=`last; :; `lastTraded]} cols x2) xcol x2 /rename last to lastTraded column
x2: `ceil`floor`symbol`statetypeval`language`mkt`lasttrade`underlying`mktlabel`settleDecimal`statetypeeval`name`openfix`sStatus _ x2
x3: `elapse`totalList`psettle`tick`bsv`nonSideNumberOfExeList`buyVolumnList _ x2
first

x3: delete priceList, nonSideNumberOfExeList, buyVolumnList, sellVolumnList, sellNumberOfExeList, buyNumberOfExeList, totalPercentList, nonSideVolumnList from x3
1000 _ x3
x2[1000]
x3: select timestamp, sym, pchg, val, chg, `last, pnonside, basis, bo, bov, ticker, vol, buyTotalVolumn, percentBuyVolumn , sellTotalVolumn, percentSellVolumn, nonSideTotalVolumn, percentNonSideVolumn, totalVolumnAllSide from x3

select timestamp, sym, lastTraded from x2

select timestamp, lastTraded, bo, bov, ticker, vol from x2

select timestamp, elapse,
flip
x2[10]
x: select timestamp, sym, ticker from x2
ticker: raze {flip `timestamp`sym`time`side`qty`price!flip (value 2#x) ,/: (4 cut x`ticker)} each x
ticker: update "T"$time, "S"$side from ticker

x: select timestamp, sym, bo, bov from x2

optCast: {[newType; data] @[data; where 10h=type each data; newType$]}


quote: raze {a: 2 cut optCast["F"] x`bo; b: 2 cut x`bov; flip `timestamp`sym`lvl`bid`ask`bidQty`askQty!flip (value 2#x) ,/: (`l1`l2`l3`l4`l5),' a,' b} each x