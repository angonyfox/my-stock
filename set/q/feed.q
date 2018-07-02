/need to run "secrets\\setenv.bat" outside q session. somehow the env does not persist if running q
system "cd c:/dev/personal/set-scripts";
system "l q/set-api.q";
system "l q/lib/timer.q";
tickers: {`tradeTime xasc flip `tradeTime`side`qty`price!flip {"TSff" {x$y}' x} each 4 cut x[`ticker]};

/wrong first 2 bo's can be ATO, ATC
normalize: {{{$[0 < type x; "F"$x; x]} each x} each x};
bov: {flip `lvl`bid`bidQty`ask`askQty!(enlist`L1`L2`L3`L4`L5),flip raze each 2 cut (,'/) normalize x[`bo`bov]};

lastQuote: (enlist`)!enlist();
getLastQuote: {lastQuote x};
fillMissingTrade: {[tr; vol_missing] ({(key x)! x[`tradeTime], `U, y, x[`price]}[first tr; vol_missing]), tr};
removeDuplicateTrades: {[tr; vol_overlap] delete cumqty from select from (update cumqty: sums qty from tr) where cumqty > vol_overlap};

newtrades: {[quotedata]
  s: `$quotedata[`symbol];
  tr: tickers quotedata;
  if[not s in raze key lastQuote; :tr];
  if[not count tr; :tr];  /if tr tickers is empty
  oldData: getLastQuote s;
  tradedVol: quotedata[`vol] - oldData[`vol];
  tickerVol: (exec sum qty from tr);
  $[tradedVol > tickerVol;
    fillMissingTrade[tr; tradedVol - tickerVol];
    removeDuplicateTrades[tr; tickerVol - tradedVol]]};

addSym: {[s; t] ([]sym: (count t)#s),'t};

feedTrade: {[s]
  dat: fastquote s;
  t: newtrades dat;
  h(".u.upd";`trade; value flip addSym[s] t);
  lastQuote[s]: dat;};

feedQuote: {[s]
  dat: getLastQuote s;
  t: bov dat;
  h(".u.upd";`quote; value flip addSym[s] t);};


h: neg hopen `:ypricing.com:5010
login[]

/warmup
feedTrade `PTG
feedQuote `PTG

seconds: 1000
/jobs ,: .timer.add[{feedTrade[`S50U16]}; 10 * seconds]
/jobs ,: .timer.add[{feedQuote[`S50U16]}; 60 * seconds]
addJobs: {
  .timer.add[{feedTrade each `CK`PTG}; 10 * seconds];
  .timer.add[{feedQuote each `CK`PTG}; 60 * seconds];
  };


/addJobs[]
at: {[t;f] .timer.once[f; `long$t - .z.T]};

at[12:00] {addJobs[]}
at[14:30] {.timer.rm each .timer.t[;0]; jobs:: ()}
at[16:30] {addJobs[]}
at[19:00] {.timer.rm each .timer.t[;0]; jobs:: ()}

/
/remove all timers
.timer.rm each .timer.t[;0]

/manually add timers
