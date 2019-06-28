/ '. ./setenv.sh'
/only need to login once per cookie session (not q session)
/system "./login_tisco.sh"
/system "./login_set.sh"

.poll.fastquote: {raze system "./fastquote.sh ", string x};

.poll.row: {[sym]
  t1: .z.p;
  dat: .poll.fastquote sym;
  t2: .z.p;
  elapse: t2 - t1;
  `timestamp`sym`elapse`data!(t2; sym; elapse; dat)}

/.poll.append: {[row] raw:: raw, row; save `raw}
.poll.append: {[row] .[`:raw; (); ,; row]}
/.poll.sym: {[sym] .poll.append .poll.row sym}


.poll.market: {
  t1: .z.p;
  dat: raze system "./marketsummary.sh";
  t2: .z.p;
  elapse: t2 - t1;
  `timestamp`sym`elapse`data!(t2; `market; elapse; dat)}

/then we repeat this set N times
.poll.set: {
  r1: .poll.market[];
  r2: .poll.row each `S50U19`S50Z19;
  r1, r2}

/start polling forever until interrupt (ctrl + c in q) - WARNING: do not run this in sublime because it will block the editor
while[1b; .poll.append .poll.set[]]
\
/to reset raw
raw: ([]timestamp: `timestamp$(); sym: `symbol$(); elapse: `timespan$(); data: ())
raw: 0#raw;save `raw
load `:raw
value `:raw
.poll.append .poll.set[]

.poll.append .poll.row `S50U19
\t .poll.do each 10#`S50U19
.poll.fastquote `SET50

