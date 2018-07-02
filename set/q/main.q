/need to run "secrets\\setenv.bat" outside q session. somehow the env does not persist if running q
system "cd c:/dev/personal/set-scripts"
system "l q/set-api.q"

tickers: {`tradeTime xasc flip `tradeTime`side`qty`price!flip {"TSff" {x$y}' x} each 4 cut x[`ticker]};

/wrong first 2 bo's can be ATO, ATC
normalize: {{{$[0 < type x; "F"$x; x]} each x} each x};
bov: {flip `lvl`bid`bidQty`ask`askQty!(enlist`L1`L2`L3`L4`L5),flip raze each 2 cut (,'/) normalize x[`bo`bov]};

/tables
trade: ([]time: `time$(); sym: `$(); tradeTime: `time$(); side: `$(); qty:`float$(); price:`float$());
quote: ([]time: `time$(); sym: `$(); lvl: `$(); bid: `float$(); bidQty:`float$(); ask:`float$(); askQty:`float$());

lastQuote: (enlist`)!enlist();
fillMissingTrade: {[tr; vol_missing] ({(key x)! x[`tradeTime], `U, y, x[`price]}[first tr; vol_missing]), tr};
removeDuplicateTrades: {[tr; vol_overlap] delete cumqty from select from (update cumqty: sums qty from tr) where cumqty > vol_overlap};

newtrades: {[quotedata]
  s: `$quotedata[`symbol];
  tr: tickers quotedata;
  if[not s in raze key lastQuote; :tr];
  if[not count tr; :tr];  /if tr tickers is empty
  oldData: (1 _ lastQuote) s;
  tradedVol: quotedata[`vol] - oldData[`vol];
  tickerVol: (exec sum qty from tr);
  $[tradedVol > tickerVol;
    fillMissingTrade[tr; tradedVol - tickerVol];
    removeDuplicateTrades[tr; tickerVol - tradedVol]]};

addCols: {[t; s] ([]sym: (count t)#s),'t};
addColsAndInsert: {[t;s;rows] t insert addCols[rows; s]};

fetchAndInsert: {[s]
  dat: fastquote s;
  addColsAndInsert[`trade; s; newtrades dat];
  addColsAndInsert[`quote; s; bov dat];
  lastQuote[s]: dat;
};

.z.ts: {
  fetchAndInsert each `S50U16`S50Z16`S50H17
}

\t 30000
\t 0
//usages
login[]
marketsummary[]

tickers fastquote `BEM
toTrades `LEE
bov 
fastquote `BEM
quotes `SYMC
quotes `LEE

mtrades `S50U16`S50Z16`S50H17
fetchPortfolio[]
fetchAndParsePortfolio[]

x: fastquote `CK
x2: fastquote `CK
lastQuote: (enlist`)!enlist()
lastQuote[`CK]: x

tickers x
bov x
trade
/pub
h: neg hopen `:ypricing.com:5010
r: 

value r
h(".u.upd";`trade; 1_value flip trade)
h(".u.upd";`quote; 1_value flip quote)
meta trade
.u.init[]
.u.w
.z.N

