/only need to login once per cookie session (not q session)
/assume working dir is ./set
/ '. ./linux/setenv.sh'
/system "./linux/login_tisco.sh"
/system "./linux/login_set.sh"

.poll.fastquote: {raze system "./linux/fastquote.sh ", string x};
.poll.market: {raze system "./linux/marketsummary.sh"};

.poll.row: {[sym]
  t1: .z.p;
  f: $[sym=`market; .poll.market; .poll.fastquote];
  dat: @[f; sym; {-1 (string .z.P), " ERROR: ", (string x), " '", y; "{}"}[sym]]; /catch curl error
  t2: .z.p;
  elapse: t2 - t1;
  `sym`timestamp`elapse`data!(sym; t2; elapse; dat)}

/.poll.append: {[row] raw:: raw, row; save `raw}
.poll.file: {`$(string `:data/raw), ssr[string .z.d; "."; ""]}
/.poll.append: {[f; row] .[f; (); ,; row]}
/.poll.append: {[f; row] .[f; (); ,; row]; h(".u.upd";`raw; value flip 1 _' row)}
.poll.append: {h (".u.upd";`raw; value flip x)}

/figure out syms to poll
/m: `market /index seems to be updated once every 10-20seconds
f1: `S50U19 /current future
f2: `S50Z19 /next future
options: `SVI, `$"S50U19" ,/: ("C1125"; "C1150"; "C1175"; "C1200"; "P1150"; "P1125"; "P1100")
.poll.oi: -1
o1: {.poll.oi :: mod[.poll.oi + 1; count options]; options[.poll.oi]} /take one from list
/.poll.syms: {`market`S50U19`S50Z19}
.poll.syms: {f1, o1[], f1, f2, f1} /gives more weight to m and f1, 2nd tier f2, o1 is last tier
/.poll.syms: {m, f1, f2, m, f1, `SVI, m, f1, f2} /gives more weight to m and f1, 2nd tier f2, o1 is last tier

.poll.all: {.poll.row each .poll.syms[]}

.poll.schedule: {[file; start; end]
  while[.z.T<=start; -1 (string .z.P), " sleeping until ", (string start); system "sleep 60"];
  -1 "polling until ", string end;
  while[.z.T<=end; .poll.append .poll.all[]]}


\
\l ./q/v2/poll.q
/ '. ./linux/setenv.sh'
system "./linux/login_tisco.sh"
system "./linux/login_set.sh"
.poll.schedule[.poll.file[]; 11:45; 14:32]
.poll.schedule[.poll.file[]; 16:30; 19:02]

h: hopen `::5000
x:.poll.all[]
value flip x
.poll.append .poll.all[]
do[5; .poll.append .poll.all[]]
.poll.schedule[.poll.file[]; 09:00; 09:56]
h

h
h(".u.upd";`raw; (`a`b; (0D01:00; 0D02:00); ("aaa"; "bbb")))
h(".u.upd";`raw; value flip 1 _' x)
h(".u.upd";`raw; value flip 1 _' x)
h(".u.upd";`raw; xx)
xx:-1 _ 1 _ value flip x
raw: ([]time:`time$(); sym:`symbol$(); elapse: `timespan$(); data: "C"$())


/start polling forever until interrupt (ctrl + c in q) - WARNING: do not run this in sublime because it will block the editor
while[1b; .poll.append .poll.all[]]
while[.z.T<=14:32; .poll.append .poll.all[]]
while[.z.T<=19:02; .poll.append .poll.all[]]


/to reset raw
raw: ([]timestamp: `timestamp$(); sym: `symbol$(); elapse: `timespan$(); data: ())
raw: 0#raw;save `raw
load `:raw
value `:raw
.poll.append[.poll.file[]] .poll.all[]
.poll.all[]

.poll.append .poll.row `S50U19
\t .poll.do each 10#`S50U19
.poll.fastquote `SET50

