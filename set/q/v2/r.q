  \o 7
/custom rdb which gets update from poll2.q
/poll2.q constantly poll market data and trigger method `upd
/at end of day (or star tof day), need to manually persist data to hdb and clear tables by calling `end and `reset (todo: automate this)
/q q/v2/r.q -p 7779 -o 7

/data
ticker: ([] time:`timespan$(); sym: `symbol$(); tradeTime: `time$(); side: `symbol$(); qty: `float$(); price: `float$())
bov: ([] time:`timespan$(); sym: `symbol$(); lvl: `symbol$(); bid: `float$(); ask: `float$(); bidQty: `float$(); askQty: `float$())
indicator: ([] time:`timespan$(); sym: `symbol$(); basis: `float$(); wprice: `float$())
lastVol: (enlist`)!enlist 0f /init empty last vol map (for deduping trades)


/common util
.parse.appendTimeSym: {[time; sym; t] c: count t; ([]time: c#time; sym: c#sym),'t}


/ticker
.parse.tickerExtract: {[raw] `tradeTime xasc flip `tradeTime`side`qty`price!flip {"TSff" {x$y}' x} each 4 cut raw[`ticker]};
.parse.tickerFillMissing: {[tr; vol_missing] ({(key x)! x[`tradeTime], `U, y, x[`price]}[first tr; vol_missing]), tr};
.parse.tickerRemoveDupe: {[tr; vol_overlap] delete cumqty from select from (update cumqty: sums qty from tr) where cumqty > vol_overlap}

.parse.tickerDedupe: {[new; lastVol]
  tr: .parse.tickerExtract new;
  tradedVol: new[`vol] - lastVol;
  tickerVol: (exec sum qty from tr);
  res: $[tradedVol > tickerVol;
    .parse.tickerFillMissing[tr; tradedVol - tickerVol];
    .parse.tickerRemoveDupe[tr; tickerVol - tradedVol]]};

/mutate lastVol
.parse.ticker: {[time; sym; dat]
  t: .parse.tickerDedupe[dat; lastVol[sym]];
  lastVol[sym]::dat[`vol]; /set last vol for sym
  .parse.appendTimeSym[time; sym; t]} /construct return table


/bov
.parse.bovOptCast: {[newType; data] @[data; where 10h=type each data; newType$]}
.parse.bovExtract: {[raw] a: 2 cut .parse.bovOptCast["F"] raw`bo; b: 2 cut raw`bov; flip `lvl`bid`ask`bidQty`askQty!flip (`L1`L2`L3`L4`L5),' a,' b}
.parse.bov: {[time; sym; dat]
  t: .parse.bovExtract[dat];
  .parse.appendTimeSym[time; sym; t]}


/subscribe loop
/t: y[0]; s: y[1]; e: y[2]; dat: y[3];
upd: {[table; row]
  time: row[0];
  sym: row[1];
  dat: .j.k row[3]; /parse json
  insert[`ticker] .parse.ticker[time; sym; dat];
  bv: .parse.bov[time; sym; dat];
  insert[`bov] bv;
  wprice: (wavg/) 10 cut raze exec bidQty, askQty, bid, ask from bv; /wrong gives too much weight on L5 -> more weight should be given to L1
  basis: (dat)`basis;
  insert[`indicator] (time; sym; basis; wprice);
  lastRow::row; /for debugging
  }

end: {[date] .Q.dpft[`:hdb; date; `sym] each `ticker`bov`indicator}
reset: {lastVol:: (enlist`)!enlist 0f; {x set 0#get x} each `ticker`bov`indicator}

/at eod call end .z.d to save data to hdb
/if call from the next day
/end .z.d - 1
/reset[]
/
bv: .parse.bov[lastRow[0]; lastRow[1]; .j.k lastRow[3]]
{x, y} over 1 2
select from bov where time >

select from bov where time within(0D10:00;0D10:05)
(raze exec bidQty, askQty from bv) wavg (raze exec bid, ask from bv)
wavg
ticker
upd[`raw; old]

first ticker
