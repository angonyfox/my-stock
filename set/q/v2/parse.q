parseJson: {(delete data from x) ,' .j.k each exec data from x}
removePreOpen: {[dat] dat where not {`openopendata2 in key x} each dat}
removeError: {x where not x[`data] like "{}"}
tt: removePreOpen parseJson select from removeError[t] where sym<>`market /doesn't work
x2: removePreOpen parseJson select from removeError[t] where sym=`S50U19
x2: removePreOpen parseJson select from t where sym=`SVI

/x: 10#x2
/x`ticker
/({enlist (x; y)}':) til 10

normalize: {{{$[0 < type x; "F"$x; x]} each x} each x};
optCast: {[newType; data] @[data; where 10h=type each data; newType$]}
bov: {a: 2 cut optCast["F"] x`bo; b: 2 cut x`bov; flip `timestamp`sym`lvl`bid`ask`bidQty`askQty!flip (value 2#x) ,/: (`L1`L2`L3`L4`L5),' a,' b}

bov: {flip `lvl`bid`bidQty`ask`askQty!(enlist`L1`L2`L3`L4`L5),flip raze each 2 cut (,'/) normalize x[`bo`bov]};

/lastQuote: (enlist`)!enlist();
/getLastQuote: {lastQuote x};
tickers: {`tradeTime xasc flip `tradeTime`side`qty`price!flip {"TSff" {x$y}' x} each 4 cut x[`ticker]};
fillMissingTrade: {[tr; vol_missing] ({(key x)! x[`tradeTime], `U, y, x[`price]}[first tr; vol_missing]), tr};
removeDuplicateTrades: {[tr; vol_overlap] delete cumqty from select from (update cumqty: sums qty from tr) where cumqty > vol_overlap};

newtrades: {[new; old]
  s: `$new[`symbol];
  tr: tickers new;
  tradedVol: new[`vol] - old[`vol];
  tickerVol: (exec sum qty from tr);
  res: $[tradedVol > tickerVol;
    fillMissingTrade[tr; tradedVol - tickerVol];
    removeDuplicateTrades[tr; tickerVol - tradedVol]];
  c: count res;
  ([]sym: c#s; timestamp: c#0D07:00+new[`timestamp]),'res};
ticker: {update tradeTime: timestamp.date + tradeTime from raze (newtrades':) x}
bovv: {update timestamp: 0D07:00+timestamp from raze bov each x}


quote: bovv x2
trade: ticker x2
