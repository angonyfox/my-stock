library(rkdb)
library(ggplot2)
library(gridExtra)
library(lubridate)
library(dplyr)

Sys.setenv(TZ='GMT') #need this or else, the timezone of t$date will be off
.ggplot.legend_bottom = theme(legend.position = "bottom")
filterByTime= function(t, from, to){t[t$timestamp>from & t$timestamp<to,]}

h3 = open_connection('localhost',7778) #this open a connection
execute(h3, "\\l q/v2/parse.q")
execute(h3, "t: get[`:data/raw20190718]")
execute(h3, "x2: .parse.removePreOpen .parse.parseJson select from .parse.removeError[t] where sym=`S50U19")

t = execute(h3, "trade: ticker x2; trade")
q = execute(h3, "quote: bov x2; quote")
b = execute(h3, "basis: bs x2; basis")

t$timestamp=as.POSIXct(t$timestamp)
t$tradeTime=as.POSIXct(t$tradeTime)
q$timestamp=as.POSIXct(q$timestamp)
b$timestamp=as.POSIXct(b$timestamp)

qty_scale=scale_size(breaks=c(25, 50, 100, 200), limits=c(1, 200), range=c(0.5, 15))
col_scale=scale_colour_manual(values=c("B" = "darkgreen", "S" = "darkred", "U" = "blue", "NS"="grey"))
shape_scale=scale_shape_manual(values=c("B" = 2, "S" = 6, "U" = 1, "NS"=0))

quote_scale=scale_fill_gradient(low="#fff2bd", high="#383200", breaks=c(20, 50, 100, 200), limits=c(1, 200))
time_scale=scale_x_datetime(date_labels="%H:%M:%S")
#time_scale=scale_x_datetime(date_breaks="10 sec", date_labels="%H:%M:%S")

#ggplot() + geom_raster(data=fq, aes(x=timestamp, y=bid, fill=bidQty), vjust=0, hjust=0) + quote_scale

#whole day
ggplot() + geom_point(data=t, aes(x=tradeTime, y=price, color=side, size=qty, shape=side)) + qty_scale + col_scale + shape_scale

#last 100 rows
ggplot() + geom_point(data=tail(t, n=100), aes(x=tradeTime, y=price, color=side, size=qty, shape=side))


  

#actually tz is Thai
#specifc period
from=as.POSIXct("2019-07-18 15:00", tz="UTC")
from=start
to=from+seconds(60)
to=as.POSIXct("2019-07-12 18:20", tz="UTC")
ft=filterByTime(t, from, to)
fq=filterByTime(q, from, to)
fb=filterByTime(b, from, to)

p=ggplot()
p=p + geom_raster(data=fq, aes(x=timestamp, y=bid, fill=bidQty), vjust=0, hjust=0) + quote_scale
p=p + geom_raster(data=fq, aes(x=timestamp, y=ask, fill=askQty), vjust=1, hjust=0) + quote_scale
p=p + geom_point(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side)) + qty_scale + col_scale + shape_scale


#overlay basis
refPrice=head(ft, n=1)$price
if (length(refPrice) == 0) refPrice=head(fq, n=1)$bid
adj=refPrice - head(fb, n=1)$basis
if (length(adj) == 0) adj=0 #if no adj
if (nrow(fb) > 0) {
  p + geom_line(data=fb, aes(x=timestamp, y=basis + adj), color="red") + scale_y_continuous(sec.axis=~ . - adj)
}else{
  p
}

ft

plot_tq=function(from, to){
  ft=filterByTime(t, from, to)
  fq=filterByTime(q, from, to)
  fb=filterByTime(b, from, to)
  
  p=ggplot()
  #quote
  p=p + geom_raster(data=fq, aes(x=timestamp, y=bid, fill=bidQty), vjust=0, hjust=0)
  p=p + geom_raster(data=fq, aes(x=timestamp, y=ask, fill=askQty), vjust=1, hjust=0) 
  #trade
  p=p + geom_point(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side)) 
  #styling
  p=p + qty_scale + col_scale + shape_scale + quote_scale + .ggplot.legend_bottom + time_scale
  #overlay basis
  refPrice=head(ft, n=1)$price
  if (length(refPrice) == 0) refPrice=head(fq, n=1)$bid
  adj=refPrice - head(fb, n=1)$basis
  if (length(adj) == 0) adj=0 #if no adj
  if (nrow(fb) > 0)
    p + geom_line(data=fb, aes(x=timestamp, y=basis + adj), color="red") + scale_y_continuous(sec.axis=~ . - adj)
  else
    p
}

plot_tq_period=function(from, period){plot_tq(from, from + period)}
plot_tq_period(from, seconds(120))



genPlots=function(start, end, period, increment, plotfn=plot_tq_period, folder="out"){
  current=start
  while (current <= end){
    print(current)
    f=paste0(folder, "/", format(current, "%Y%m%d_%H%M%S"), ".png")
    pl=plotfn(current, period)
    ggsave(filename=f, plot=pl, width=6, height=4, units="in")
    current=current+increment
  }
}
head(t)
start=as.POSIXct("2019-07-12 15:07:56", tz="UTC")
start=as.POSIXct("2019-07-12 12:10:54", tz="UTC")
end=as.POSIXct("2019-07-12 16:32", tz="UTC")
genPlots(start, end, period=seconds(60), increment=seconds(1), folder="out")

plot_tq_period(start, seconds(60))
plot_tq_period(as.POSIXct("2019-07-15 10:30:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:31:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:32:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:33:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:34:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:35:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:36:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:37:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:38:00", tz="UTC"), seconds(120))
plot_tq_period(as.POSIXct("2019-07-15 10:39:00", tz="UTC"), seconds(120))

#then generate video with
#ffmpeg -framerate 1 -pattern_type glob -i '*.png' -c:v libx264 -pix_fmt yuv420p out.mp4

#todo
#proper scale: bid/ask qty, side, trade qty
#add volume per min/second bar
#add wavg price
#shiny
#  -dynamic timeframe
#  -auto refresh
