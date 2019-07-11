.parse.parseJson: {(delete data from x) ,' .j.k each exec data from x}
.parse.removePreOpen: {[dat] dat where not {`openopendata2 in key x} each dat}
.parse.removeError: {x where not x[`data] like "{}"}

.parse.normalize: {{{$[0 < type x; "F"$x; x]} each x} each x};
.parse.optCast: {[newType; data] @[data; where 10h=type each data; newType$]}
.parse.bov: {a: 2 cut .parse.optCast["F"] x`bo; b: 2 cut x`bov; flip `timestamp`sym`lvl`bid`ask`bidQty`askQty!flip (value 2#x) ,/: (`L1`L2`L3`L4`L5),' a,' b}

/lastQuote: (enlist`)!enlist();
/getLastQuote: {lastQuote x};
.parse.ticker: {`tradeTime xasc flip `tradeTime`side`qty`price!flip {"TSff" {x$y}' x} each 4 cut x[`ticker]};
.parse.fillMissingTrade: {[tr; vol_missing] ({(key x)! x[`tradeTime], `U, y, x[`price]}[first tr; vol_missing]), tr};
.parse.removeDuplicateTrades: {[tr; vol_overlap] delete cumqty from select from (update cumqty: sums qty from tr) where cumqty > vol_overlap};

.parse.newtrades: {[new; old]
  s: `$new[`symbol];
  tr: .parse.ticker new;
  tradedVol: new[`vol] - old[`vol];
  tickerVol: (exec sum qty from tr);
  res: $[tradedVol > tickerVol;
    .parse.fillMissingTrade[tr; tradedVol - tickerVol];
    .parse.removeDuplicateTrades[tr; tickerVol - tradedVol]];
  c: count res;
  ([]sym: c#s; timestamp: c#new[`timestamp]),'res};

ticker: {update timestamp: 0D07:00+timestamp, tradeTime: timestamp.date + tradeTime from raze (.parse.newtrades':) x}
bov: {update timestamp: 0D07:00+timestamp from raze .parse.bov each x}
bs: {select timestamp+0D07:00, sym, basis from x}


\
/assume q working dir is ./set/
\l q/v2/parse.q

t: get[`:data/raw]
t: get[`:data/raw_20190704]

tt: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym<>`market /doesn't work
x2: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym=`S50U19
x2: .parse.removePreOpen .parse.parseJson select from t where sym=`SVI

/x: 10#x2
/x`ticker
/({enlist (x; y)}':) til 10


basis: bs x2
quote: bov x2
trade: ticker x2
