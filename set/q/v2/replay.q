\l q/v2/r.q

ticker
bov
indicator
last indicator

reset[]
t: get[`:data2/raw20190902]
{@[upd[`raw];  value x; {-1 (string .z.P), " ERROR: upd '", x}]} each t
end 2019.09.02