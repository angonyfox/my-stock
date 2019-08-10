source("tq/plot.r")

#for experiment with different plot
plot_tqbx=function(dat){
  ft=dat[["t"]]
  fq=dat[["q"]]
  fb=dat[["b"]]
  
  p=ggplot()
  #quote
  p=p + geom_raster(data=fq, aes(x=time, y=bid, fill=bidQty), vjust=0, hjust=0)
  p=p + geom_raster(data=fq, aes(x=time, y=ask, fill=askQty), vjust=1, hjust=0) 
  #trade
  p=p + geom_jitter(data=ft, aes(x=tradeTime, y=price, color=side, size=qty, shape=side), width=0, height=0.035) 
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

dat=load_period("0D10:34", "0D10:35")
plot_tqb(dat)
plot_tqbx(dat)
dat[["t"]]

hhdb = open_connection('localhost',7778) #this open a connection

dat=load_period_hdb("2019.08.07", "0D10:00", "0D10:01")
plot_tqb(dat)
dat[["q"]]

x=gsub("-", ".", c("2019-08-08"))
print(x)