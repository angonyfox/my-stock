/assume q working dir is ./set/
\l q/v2/parse.q

t: get[`:data/raw]
t: get[`:data/raw_20190704]

tt: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym<>`market /doesn't work
x2: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym=`S50U19
x2: .parse.removePreOpen .parse.parseJson select from t where sym=`SVI