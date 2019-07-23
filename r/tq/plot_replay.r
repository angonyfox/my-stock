source("tq/plot.r")

genPlots=function(start, end, period, increment, plotfn=plot_tq_period, folder_prefix="out"){
  folder=paste0(folder_prefix, format(start, "%Y%m%d"))
  dir.create(folder)
  current=start
  f=paste0(folder, "/live.png")
  while (current <= end){
    print(current)
    #f=paste0(folder, "/", format(current, "%H%M%S"), ".png")
    pl=plotfn(current, period)
    ggsave(filename=f, plot=pl, dpi=120, width=10, height=6, units="in")
    current=current+increment
  }
}

plf=function(start, period){plot_tqb(load_period_window(as.qtimespan(start), period)) + theme(legend.position="none")}
as.qtimespan=function(posixct){format(posixct, "0D%H:%M:%S")}

start=as.POSIXct("2019-07-22 10:00:00", tz="UTC")
end=as.POSIXct("2019-07-22 10:01:00", tz="UTC")
#plot_tqb(load_period_window("0D10:00:00", "0D00:02:00"))
#plot_tqb(load_period_window(as.qtimespan(start), "0D00:01:00"))
#plf(start, "0D00:01:00")
genPlots(start, end, period="0D00:01:00", increment=seconds(1), plotfn=plf, folder="out")
