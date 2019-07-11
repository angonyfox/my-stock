library(rkdb)
library(ggplot2)
h3 = open_connection('localhost',7778) #this open a connection
t = execute(h3, "update date:2019.06.28 + time from select from ticker where sym=`S50U19")
t = execute(h3, "update date:2019.07.01 + time from select from ticker where sym=`S50U19")
t = execute(h3, "update date:timestamp.date + time from ticker")

t$date = as.POSIXct(t$date, tz="UTC") #handle nanotime

head(t)
ggplot(t, aes(x=date, y=price, size=qty, color=side)) + geom_point()
ggplot(t[t$date<as.POSIXct("2019-07-04 13:00:00", tz="UTC"),], aes(x=date, y=price, size=qty, color=side)) + geom_point()

dat=t[t$date>as.POSIXct("2019-07-04 14:30:00", tz="UTC") & t$date<as.POSIXct("2019-07-04 17:00:00", tz="UTC"),]
dat=t[t$qty>50,]
dat=dat[dat$qty>50,]

ggplot(dat, aes(x=date, y=price, size=qty, color=side)) + geom_point()
ggplot(dat, aes(x=date, y=qty, size=qty, color=side)) + geom_point()

ggplot(t[t$qty>50,], aes(x=date, y=price, size=qty, color=side)) + geom_point()
ggplot(t, aes(x=date, y=qty, size=qty, color=side)) + geom_point()
ggplot(t[t$qty>10,], aes(x=date, y=qty, size=qty, color=side)) + geom_point()

t$date

t = execute(h3, "trade")
q = execute(h3, "quote")

t$timestamp=as.POSIXct(t$timestamp)
t$tradeTime=as.POSIXct(t$tradeTime)
q$timestamp=as.POSIXct(q$timestamp)

filterByTime= function(t, from, to){t[t$timestamp>as.POSIXct(from, tz="UTC") & t$timestamp<as.POSIXct(to, tz="UTC"),]}
head(t)
head(q)

t
dat=filterByTime(t, "2019-07-09 10:00:00", "2019-07-09 11:00:00")
dat2=filterByTime(q, "2019-07-09 10:00:00", "2019-07-09 11:00:00")
head(dat2)

p=ggplot()
p=p + geom_raster(data=dat2, aes(x=timestamp, y=bid, fill=bidQty), vjust=0)
p=p + geom_raster(data=dat2, aes(x=timestamp, y=ask, fill=askQty), vjust=1)
p=p + geom_point(data=dat, aes(x=tradeTime, y=price, color=side, size=qty, shape=side))
p
