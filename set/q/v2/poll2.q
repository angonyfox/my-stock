/only need to login once per cookie session (not q session)
/assume working dir is ./set
/ '. ./linux/setenv.sh'
/system "./linux/login_tisco.sh"
/system "./linux/login_set.sh"
/starts with local time zone -o 7

/fetch market data, then trigger `upd on r.q. also persist raw data to `:data2/raw
/at start of day, need to manually renew file name (todo: automate this)
/q -p 7777 -o 7
\o 7
.poll.fastquote: {raze system "./linux/fastquote.sh ", string x};

.poll.fetch: {[sym]
  t1: .z.P;
  dat: @[.poll.fastquote; sym; {-1 (string .z.P), " ERROR: ", (string x), " '", y; "{}"}[sym]]; /catch curl error
  t2: .z.P;
  elapse: t2 - t1;
  `time`sym`elapse`data!("n"$t2; sym; elapse; dat)}

/.poll.append: {[row] raw:: raw, row; save `raw}
.poll.file: {`$(string `:data2/raw), ssr[string .z.D; "."; ""]}
.poll.append: {[f; row] .[f; (); ,; row]}
.poll.pub: {[h; row] h (`upd; `raw; value row)}

.poll.schedule: {[f; start; end]
  while[.z.T<=start; -1 (string .z.P), " sleeping until ", (string start); system "sleep 60"];
  -1 "polling until ", string end;
  while[.z.T<=end; f[]]}

.poll.doAll: {[sym; file; h]
  x: .poll.fetch[sym];
  @[.poll.pub[h]; x; {-1 (string .z.P), " ERROR: pub '", x}];
  @[.poll.append[file]; enlist x; {-1 (string .z.P), " ERROR: append '", x}]}

f: .poll.file[]
h: hopen `::7779


\
\l ./q/v2/poll2.q
/ '. ./linux/setenv.sh'
system "./linux/login_tisco.sh"
system "./linux/login_set.sh"

/thai time
f: .poll.file[]
.poll.schedule[{.poll.doAll[`S50U19; f; h]}; 09:45; 12:32]
.poll.schedule[{.poll.doAll[`S50U19; f; h]}; 14:15; 17:00]

/test
.poll.doAll[`S50U19; f; h]
.poll.fetch `S50U19

/fix broken raw
t: get[`:data2/raw20190808]
t2:29900 # t
set[`:data2/raw20190726] t2
set[`:data2/raw20190725] t2
