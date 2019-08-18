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

#for analysing ticker file downloaded from SET
head(t)
tail(t)
str(t)

t = read.csv(file="ticker/XO_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/SVI_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/NER_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/SCB_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/CPALL_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/AOT_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/20190815/OSP/All_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/20190815/CPALL/All_Ticker_2019-08-15.csv", header=TRUE, sep=",")
t = read.csv(file="ticker/csv/20190816/CPALL.csv", header=TRUE, sep=",")

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
  t=read.csv(file=paste0("ticker/", date,"/", sym, "/All_Ticker_2019-08-16.csv"), header=TRUE, sep=",")
  return(normalize_ticker(t) %>% mutate(sym=sym))
}

plot_ticker=function(ft, max_size=20){
  title=paste(first(ft$date), "-", first(ft$sym))
  p = ggplot(ft, aes(x=tradeTime, y=price, col=side, shape=side, size=qty)) + geom_point() 
  p1 = p + .scale.side_col + .scale.side_shape + scale_size(range=c(0.1, max_size)) + clean_theme + ggtitle(title)
  
  #p = ggplot(ft, aes(x=tradeTime, y=qty, col=side, shape=side, size=qty)) + geom_point() 
  #p2 = p + .scale.side_col + .scale.side_shape + scale_size(range=c(0.1, max_size)) + clean_theme
  
  vpm=ft %>% group_by(time=as.POSIXct(floor_date(tradeTime, unit="minute")), side, session) %>% summarise(qty=sum(qty))
  p3=ggplot(vpm, aes(x=time, y=qty/1000, fill=side, col=side)) + geom_col() + .scale.side_fill + .scale.side_col + clean_theme + scale_y_continuous(label=unit_format(unit="k"))
  
  cpm=ft %>% group_by(time=as.POSIXct(floor_date(tradeTime, unit="minute")), side, session) %>% summarise(n = n())
  p4=ggplot(cpm, aes(x=time, y=n, fill=side, col=side)) + geom_col() + .scale.side_fill + .scale.side_col + clean_theme
  
  #pp=p1 + p2 + p3 + p4 + plot_layout(ncol=1)
  pp=p1 + p3 + p4 + plot_layout(ncol=1)
  pp=pp * facet_grid(.~session, scales = "free_x")  
  return(pp)
}

filename=function(f){return(strsplit(f, "[.]")[[1]][1])}

t=load_ticker_file("20190815", "ADVANC")
plot_ticker(t)
plot_ticker(load_ticker_file("20190815", "XO"))
plot_ticker(load_ticker_file("20190815", "SCB"))
plot_ticker(load_ticker_file("20190815", "CPF") %>% filter(side != "U"))
plot_ticker(load_ticker_file("20190815", "BBL") %>% filter(side != "U"))


foreach(sym=list.files("ticker/csv/20190816")) %do% print(sym)
unlink(paste0("ticker/output/", d))
d="20190815"
dir.create(paste0("ticker/output/", d))
foreach(sym=list.files(paste0("ticker/csv/", d))) %do% 
  ggsave(
    plot=plot_ticker(load_ticker_file(d, filename(sym))),
    filename=paste0("ticker/output/", d, "/", filename(sym), ".png"), 
    dpi=120, width=10, height=12, units="in"
    )

t=load_ticker_file("20190816", "ADVANC")
#filter
t=t %>% filter(side != "U") # remove opening auction so we can get better scale Volume

ft=t
ft=t %>% filter(time >= hm("12:00") & hm("12:20") >= time ) # remove opening auction so we can get better scale Volume
ft=t %>% filter(session=="mng") # remove opening auction so we can get better scale Volume
ft=t %>% filter(session=="aft") # remove opening auction so we can get better scale Volume

plot_ticker(ft)


#only plot small Volume - to see algo or retail orders
ft=t %>% filter(qty <= 10000)
ft=t %>% filter(qty <= 1000)
#only plot big Volume - to see big market movers
ft=t %>% filter(qty >= 10000)