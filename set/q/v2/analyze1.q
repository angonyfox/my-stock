load `$":data/raw_20190628"
load `$":data/raw_20190702"
load `$":data/raw_20190709"
t: raw_20190709

t: select from t where not data like "{}"
parseJson: {(delete data from x) ,' .j.k each exec data from x}


market: parseJson select from t where sym=`market

2#market
cols market
select index from market
exec first index from market
first market
market: update `$estatus from `brokerid`physicalstatus`agriculturalstatus`enstatus`ststatus`irstatus`ccstatus`mtstatus`dstatus _ market
x: 1000#select from market where estatus=`Open1

x: `loserp`loserl`volumel`gainerl`volumep`gainerp`oidate`cindex _ x

index: (`timestamp`sym # market) ,' flip {{"F"$(x except ",")} each x} each (`s100`s50)!flip exec index[;5 10] from market
index

/price
price: select from t where sym<>`market
price: (delete data from price) ,' .j.k each exec data from price


bo: (`timestamp`sym # price) ,' flip (`bid`offer)!flip exec {"F"$x} each bo[;0 1] from price

/ticker
x: select timestamp, sym, ticker from price
ticker: raze {flip `timestamp`sym`time`side`qty`price!flip (value 2#x) ,/: (4 cut x`ticker)} each x
ticker: update "T"$time, "S"$side from ticker

ticker
/r
/h3 = open_connection('localhost',7778) #this open a connection
/t = execute(h3, "update date:2019.06.28 + time from select from ticker where sym=`S50U19")
/t$date = as.POSIXct(t$date, tz="UTC") #handle nanotime
/head(t)
/ggplot(t, aes(x=date, y=price, size=qty, color=side)) + geom_point()
/ggplot(t[t$qty>50,], aes(x=date, y=price, size=qty, color=side)) + geom_point()
/ggplot(t, aes(x=date, y=qty, size=qty, color=side)) + geom_point()
/ggplot(t[t$qty>10,], aes(x=date, y=qty, size=qty, color=side)) + geom_point()


t1: select `datetime$timestamp, s50 from index
t2: select `datetime$timestamp, bid, offer from price where sym=`S50U19
aj t1t2
tt: aj[`timestamp; t1; t2]
tt: update `datetime$timestamp from tt
select timestamp, spread: s50 - offer from tt
select timestamp, s50 - 6, bid, offer from tt
tt

