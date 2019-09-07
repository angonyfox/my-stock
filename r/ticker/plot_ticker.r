library(lubridate)
library(patchwork)
library(dplyr)
library(foreach)
library(scales)

source("tq/scale.r")
#mass convert xlsx to csv in fish shell
#pip install xlsx2csv
#for file in *
#  xlsx2csv $file/All_Ticker_2019-08-15.xlsx> $file/All_Ticker_2019-08-15.csv
#end

#t = read.csv(file="ticker/csv/20190816/CPALL.csv", header=TRUE, sep=",")

#todo
#add date to plot title
#improve folder organization and loading

#transform data types
dummyDate=date("2019-08-15") #need dummy date because ggplot requires POSIXct, but because the plot is intraday, we don't care about date anyway
normalize_ticker=function(t){
  t %>% transmute(
    time=hms(Time), 
    tradeTime=as.POSIXct(dummyDate + time), 
    side=plyr::mapvalues(t$Side, from=c(" "), to=c("U")),
    qty=Volume,
    price=Price,
    session=factor(ifelse(time <= hm("12:30"), "mng", "aft"), levels=c("mng", "aft"))
  )
}

load_ticker_file=function(date, sym){
  t=read.csv(file=paste0("ticker/csv/", date,"/", sym, ".csv"), header=TRUE, sep=",")
  return(normalize_ticker(t) %>% mutate(date=date, sym=sym))
}

.ggplot.get_ylim=function(p){return(ggplot_build(p)$layout$panel_scales_y[[1]]$range$range)}
plot_ticker=function(ft, max_size=20){
  title=paste(first(ft$date), "-", first(ft$sym))
  p = ggplot(ft, aes(x=tradeTime, y=price, col=side, shape=side, size=qty)) + geom_point() 
  p1 = p + .scale.side_col + .scale.side_shape + scale_size(range=c(0.1, max_size)) + clean_theme + ggtitle(title)
  
  #p = ggplot(ft, aes(x=tradeTime, y=qty, col=side, shape=side, size=qty)) + geom_point() 
  #p2 = p + .scale.side_col + .scale.side_shape + scale_size(range=c(0.1, max_size)) + clean_theme
  
  pm=ft %>% group_by(time=as.POSIXct(floor_date(tradeTime, unit="minute")), side, session) %>% summarise(qty=sum(qty), n=n())
  cumpm=pm %>% group_by(side, session) %>% mutate(cumqty=cumsum(qty), cumn=cumsum(n))
  lastcumpm=cumpm %>% summarise(time=last(time), cumqty=last(cumqty), cumn=last(cumn))
  
  #volume
  p3=ggplot() + geom_col(data=pm, aes(x=time, y=qty/1000, fill=side, col=side))
  ylim=.ggplot.get_ylim(p3)
  yscale=ylim[2]/max(cumpm$cumqty)
  p3=p3 + geom_line(data=cumpm, aes(x=time,  y=cumqty*yscale/1000, col=side)) 
  p3=p3+geom_text(data=lastcumpm, aes(x=time, y=cumqty*yscale/1000, label=format(round(cumqty/1000, 0), big.mark=",")), hjust=1, vjust=0)
  p3=p3+ .scale.side_fill + .scale.side_col + clean_theme + scale_y_continuous(label=unit_format(unit="k"))
  #count
  #p4=ggplot(pm, aes(x=time, y=n, fill=side, col=side)) + geom_col() + .scale.side_fill + .scale.side_col + clean_theme
  p4=ggplot() + geom_col(data=pm, aes(x=time, y=n, fill=side, col=side)) 
  ylim=.ggplot.get_ylim(p4)
  yscale=ylim[2]/max(cumpm$cumn)
  
  p4=p4 + geom_line(data=cumpm, aes(x=time,  y=cumn*yscale, col=side)) 
  p4=p4+geom_text(data=lastcumpm, aes(x=time, y=cumn*yscale, label=format((cumn), big.mark=",")), hjust=1, vjust=0)
  p4=p4 + .scale.side_fill + .scale.side_col + clean_theme
  
  #pp=p1 + p2 + p3 + p4 + plot_layout(ncol=1)
  pp=p1 + p3 + p4 + plot_layout(ncol=1)
  pp=pp * facet_grid(.~session, scales = "free_x")  
  return(pp)
}

plot_sideBySide=function(d1, s1, d2, s2){
  p1 = plot_ticker(load_ticker_file(d1, filename(s1)))
  p2 = plot_ticker(load_ticker_file(d2, filename(s2)))
  return(p1 - p2)
}