/ '. ./setenv.sh'
/only need to login once per cookie session (not q session)
/system "./login_tisco.sh"
/system "./login_set.sh"

.poll.fastquote: {raze system "./fastquote.sh ", string x};
.poll.market: {raze system "./marketsummary.sh"};

.poll.row: {[sym]
  t1: .z.p;
  dat: $[sym=`market; .poll.market[]; .poll.fastquote[sym]];
  t2: .z.p;
  elapse: t2 - t1;
  `timestamp`sym`elapse`data!(t2; sym; elapse; dat)}

/.poll.append: {[row] raw:: raw, row; save `raw}
.poll.append: {[row] .[`:raw; (); ,; row]}

/figure out syms to poll
m: `market
f1: `S50U19 /current future
f2: `S50Z19 /next future
options: `$"S50U19" ,/: ("C1125"; "C1150"; "C1175"; "C1200"; "P1150"; "P1125"; "P1100")
.poll.oi: -1
o1: {.poll.oi :: mod[.poll.oi + 1; count options]; options[.poll.oi]} /take one from list
/.poll.syms: {`market`S50U19`S50Z19}
.poll.syms: {m, f1, f2, m, f1, o1[], m, f1, f2} /gives more weight to m and f1, 2nd tier f2, o1 is last tier

.poll.all: {.poll.row each .poll.syms[]}
/.poll.all[]

/start polling forever until interrupt (ctrl + c in q) - WARNING: do not run this in sublime because it will block the editor
while[1b; .poll.append .poll.all[]]
while[.z.T<=19:02; .poll.append .poll.all[]]
\
/to reset raw
raw: ([]timestamp: `timestamp$(); sym: `symbol$(); elapse: `timespan$(); data: ())
raw: 0#raw;save `raw
load `:raw
value `:raw
.poll.append .poll.all[]
.poll.set[]

.poll.append .poll.row `S50U19
\t .poll.do each 10#`S50U19
.poll.fastquote `SET50

