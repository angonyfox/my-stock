#!/usr/bin/env Rscript
#run from command line
#tq/plot_live_1m.r
#generate real-time market depth plot live/live.png using last 1 minute data from r.q
source("tq/plot.r")

plot_live=function(window, file){
  p=plot_tqb(load_window(window))+ theme(legend.position="none")
  ggsave(filename=file, plot=p, dpi=120, width=10, height=6, units="in")
}

print("generating live plot to live/live.png every 0.1 second...")
while(TRUE){
  plot_live("0D00:01", "live/live.png")
  Sys.sleep(0.1)
}

#note the script will error if there is no data in kdb
#todo: fix
#error example
#Error in if (n2%%n1) warning("length(e2) not a multiple length(e1)") :
#argument is not interpretable as logical
#Calls: plot_live ... as.POSIXct.nanotime -> as.POSIXct -> /.integer64 -> binattr
#In addition: There were 50 or more warnings (use warnings() to see the first 50)
#Execution halted