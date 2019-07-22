/assume q working dir is ./set/
\l q/v2/parse.q


t: get[`:data/raw20190712]

tt: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym<>`market /doesn't work
x2: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym=`S50U19
x2: .parse.removePreOpen .parse.parseJson select from t where sym=`SVI

t: -10#get[`:data/raw20190718]

raw: ([]time:`time$(); sym:`symbol$(); elapse: `timespan$(); data: `char$())
ticker x2

h: hopen `::7779
.poll.pub: {[h; row] neg[h] (`upd; `raw; value row)}

 h
x: update "n"$timestamp from select from t where sym=`S50U19, timestamp.time within (03:30; 03:32)
.poll.pub[h; value last x]

neg[h] (`upd; `raw; value last x)