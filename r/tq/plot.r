library(rkdb)
library(ggplot2)
library(gridExtra)
library(lubridate)
library(dplyr)
library(patchwork)

source("tq/scale.r")

Sys.setenv(TZ='GMT') #need this or else, the timezone of t$date will be off
.ggplot.legend_bottom = theme(legend.position = "bottom")

load_cond=function(h, cond){
  #t = execute(hrdb, paste("update time + .z.d, tradeTime + .z.d from select from ticker where ", cond))
  t = execute(h, paste("update time + .z.d, tradeTime:time + .z.d from select from ticker where ", cond))
  q = execute(h, paste("update time + .z.d from select from bov where ", cond))
  b = execute(h, paste("update time + .z.d from select from indicator where ", cond))
  #t %>% mutate(time=as.POSIXct(time), tradeTime=as.POSIXct(tradeTime))
  #q %>% mutate(time=as.POSIXct(time))
  #b %>% mutate(time=as.POSIXct(time))
  t$time=as.POSIXct(t$time)
  t$tradeTime=as.POSIXct(t$tradeTime)
  q$time=as.POSIXct(q$time)
  b$time=as.POSIXct(b$time)
  return(list("t"=t, "q"=q, "b"=b))
}

load_window=function(window){load_cond(hrdb, paste0("time > .z.P - ", window))}
load_period=function(from, to){load_cond(hrdb, paste0("time within(", from, ";", to, ")"))}
load_period_window=function(from, window){load_cond(hrdb, paste0("time within(", from, ";", from, "+", window, ")"))}
load_period_hdb=function(date, from, to){load_cond(hhdb, paste0("date=", date, ",time within(", from, ";", to, ")"))}
load_period_window_hdb=function(date, from, window){load_cond(hhdb, paste0("date=", date, ",time within(", from, ";", from, "+", window, ")"))}

plot_tqb=function(dat){
  ft=dat[["t"]]
  fq=dat[["q"]]
  fb=dat[["b"]]
  
  p=ggplot()
  #quote
  p=p + geom_raster(data=fq, aes(x=time, y=bid, fill=bidQty), vjust=0, hjust=0)
  p=p + geom_raster(data=fq, aes(x=time, y=ask, fill=askQty), vjust=1, hjust=0) 
  #trade
  #p=p + geom_point(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side))
  p=p + geom_jitter(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side), width=0.2, height=0)
  #styling
  p=p + .scale.qty + .scale.side_col + .scale.side_shape + .scale.quote_fill + .ggplot.legend_bottom + .scale.time
  #overlay basis
  refPrice=head(ft, n=1)$price
  if (length(refPrice) == 0) refPrice=head(fq, n=1)$bid
  adj=refPrice - head(fb, n=1)$basis
  if (length(adj) == 0) adj=0 #if no adj
  if (nrow(fb) > 0) {
    p=p + geom_line(data=fb, aes(x=time, y=basis + adj), color="red") + scale_y_continuous(sec.axis=~ . - adj)
    #p=p + geom_line(data=fb, aes(x=time, y=wprice), color="blue")
  }
  p
}
add_volume=function(p, t, vol_limit=NA){
  p=p + theme_bw_clean
  p_ggb=ggplot_build(p)
  xlim=as.POSIXct(p_ggb$layout$panel_scales_x[[1]]$range$range, origin = "1970-01-01")
  ylim=p_ggb$layout$panel_scales_y[[1]]$range$range
  
  p1=ggplot() + geom_col(data=t, aes(x=price, y=qty, fill=side)) + coord_flip()
  p1=p1 + .scale.side_fill + scale_x_continuous(limits=ylim)
  if (!is.na(vol_limit)) {
    p1=p1 + scale_y_continuous(limits=c(0, vol_limit))
  }
  p1=p1 + theme_bw_clean + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
  
  p3=ggplot() + geom_col(data=t, aes(x=tradeTime, y=qty, fill=side))
  p3=p3 + .scale.side_fill + scale_x_datetime(limits=xlim)
  if (!is.na(vol_limit)) {
    p3=p3 + scale_y_continuous(limits=c(0, vol_limit)) 
  }
  p3=p3 + theme_bw_clean + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
  
  p1 + p + plot_spacer() + p3 + plot_layout(widths=c(0.2, 0.8), heights=c(0.8, 0.2))
}
plot_tqbv=function(dat, vol_limit=NA){
  p=plot_tqb(dat)
  add_volume(p, dat[["t"]], vol_limit=vol_limit)
}
if (FALSE) {
  dat=load_window("0D00:30")
  dat
  p=plot_tqb(dat)
  add_volume(p, dat[["t"]])
  add_volume(p, dat[["t"]], vol_limit=1000)
  plot_tqbv(dat)
}
