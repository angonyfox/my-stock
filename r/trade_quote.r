library(rkdb)
library(ggplot2)
library(gridExtra)
library(lubridate)
Sys.setenv(TZ='GMT') #need this or else, the timezone of t$date will be off
.ggplot.legend_bottom = theme(legend.position = "bottom")
filterByTime= function(t, from, to){t[t$timestamp>from & t$timestamp<to,]}

h3 = open_connection('localhost',7778) #this open a connection

execute(h3, "t: get[`:data/raw]")
execute(h3, "t: get[`:data/raw_20190704]")
execute(h3, "x2: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym=`S50U19")

t = execute(h3, "trade: ticker x2; trade")
q = execute(h3, "quote: bov x2; quote")
b = execute(h3, "basis: bs x2; basis")

t$timestamp=as.POSIXct(t$timestamp)
t$tradeTime=as.POSIXct(t$tradeTime)
q$timestamp=as.POSIXct(q$timestamp)
b$timestamp=as.POSIXct(b$timestamp)

#whole day
#ggplot() + geom_point(data=t, aes(x=tradeTime, y=price, color=side, size=qty, shape=side))

#last 100 rows
ggplot() + geom_point(data=tail(t, n=100), aes(x=tradeTime, y=price, color=side, size=qty, shape=side))

#actually tz is Thai
#specifc period
from=as.POSIXct("2019-07-11 11:09", tz="UTC")
to=from + seconds(660)
to=as.POSIXct("2019-07-11 10:20", tz="UTC")
ft=filterByTime(t, from, to)
fq=filterByTime(q, from, to)
fb=filterByTime(b, from, to)

p=ggplot()
p=p + geom_raster(data=fq, aes(x=timestamp, y=bid, fill=bidQty), vjust=0, hjust=0)
p=p + geom_raster(data=fq, aes(x=timestamp, y=ask, fill=askQty), vjust=1, hjust=0)
p=p + geom_point(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side))

#overlay basis
adj=(head(ft, n=1)$price) - head(fb, n=1)$basis
p + geom_line(data=fb, aes(x=timestamp, y=basis + adj), color="red") + scale_y_continuous(sec.axis=~ . - adj)


p2=ggplot() + geom_line(data=fb, aes(x=timestamp, y=basis), color="red") 

grid.arrange(p + .ggplot.legend_bottom, p2)
#todo
#proper scale: bid/ask qty, side, trade qty
#add volume per min/second bar
#add wavg price
#shiny
#  -dynamic timeframe
#  -auto refresh
