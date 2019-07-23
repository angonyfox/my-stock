library(rkdb)
library(ggplot2)
library(gridExtra)
library(lubridate)
library(dplyr)

source("tq/scale.r")

Sys.setenv(TZ='GMT') #need this or else, the timezone of t$date will be off
.ggplot.legend_bottom = theme(legend.position = "bottom")
h3 = open_connection('localhost',7779) #this open a connection

load_cond=function(cond){
  t = execute(h3, paste("update time + .z.d, tradeTime + .z.d from select from ticker where ", cond))
  q = execute(h3, paste("update time + .z.d from select from bov where ", cond))
  b = execute(h3, paste("update time + .z.d from select from indicator where ", cond))
  #t %>% mutate(time=as.POSIXct(time), tradeTime=as.POSIXct(tradeTime))
  #q %>% mutate(time=as.POSIXct(time))
  #b %>% mutate(time=as.POSIXct(time))
  t$time=as.POSIXct(t$time)
  t$tradeTime=as.POSIXct(t$tradeTime)
  q$time=as.POSIXct(q$time)
  b$time=as.POSIXct(b$time)
  return(list("t"=t, "q"=q, "b"=b))
}

load_window=function(window){load_cond(paste0("time > .z.P - ", window))}
load_period=function(from, to){load_cond()}
load_period_window=function(from, window){load_cond(paste0("time within(", from, ";", from, "+", window, ")"))}
plot_tqb=function(dat){
  ft=dat[["t"]]
  fq=dat[["q"]]
  fb=dat[["b"]]
  
  p=ggplot()
  #quote
  p=p + geom_raster(data=fq, aes(x=time, y=bid, fill=bidQty), vjust=0, hjust=0)
  p=p + geom_raster(data=fq, aes(x=time, y=ask, fill=askQty), vjust=1, hjust=0) 
  #trade
  p=p + geom_point(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side)) 
  #styling
  p=p + .scale.qty + .scale.side_col + .scale.side_shape + .scale.quote_fill + .ggplot.legend_bottom + .scale.time
  #overlay basis
  refPrice=head(ft, n=1)$price
  if (length(refPrice) == 0) refPrice=head(fq, n=1)$bid
  adj=refPrice - head(fb, n=1)$basis
  if (length(adj) == 0) adj=0 #if no adj
  if (nrow(fb) > 0) {
    p=p + geom_line(data=fb, aes(x=time, y=basis + adj), color="red") + scale_y_continuous(sec.axis=~ . - adj)
    p=p + geom_line(data=fb, aes(x=time, y=wprice), color="blue")
  }
  p
}

