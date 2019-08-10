#!/usr/bin/env Rscript
#run from command line
#tq/plot_live_1m.r
#generate real-time market depth plot live/live.png using last 1 minute data from r.q
source("tq/plot.r")

print_error=function(x){print(paste(with_tz(Sys.time(), tzone="Japan"), x))}
plot_live=function(window, file){
  dat=load_window(window)
  p=plot_tqb(dat)
  p=add_volume(p, dat[["t"]], vol_limit=400)
  ggsave(filename=file, plot=p, dpi=120, width=8, height=4, units="in")
}

print("generating live plot to live/live.png every 0.1 second...")
while(TRUE){
  tryCatch({
    plot_live("0D00:00:30", "live/live.png")
  }, error=function(x){
    #We'll get this kind of error if no data, so need to catch it to keep the script running
    #  Error in if (n2%%n1) warning("length(e2) not a multiple length(e1)") : argument is not interpretable as logical
    #  Calls: plot_live ... as.POSIXct.nanotime -> as.POSIXct -> /.integer64 -> binattr
    print_error(paste0("maybe no data? (", x, ")"))
  })
  Sys.sleep(0.1)
}

if(FALSE){
  #test code
  plot_live("0D00:01", "test.png")
}