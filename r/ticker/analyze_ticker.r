source("ticker/plot_ticker.r")
t=load_ticker_file("20190829", "PTT")
plot_ticker(t)
plot_ticker(load_ticker_file("20190822", "CK"))
plot_ticker(load_ticker_file("20190815", "SCB"))
plot_ticker(load_ticker_file("20190815", "CPF") %>% filter(side != "U"))
plot_ticker(load_ticker_file("20190815", "BBL") %>% filter(side != "U"))

filename=function(f){return(strsplit(f, "[.]")[[1]][1])}

foreach(sym=list.files("ticker/csv/20190816")) %do% print(sym)
unlink(paste0("ticker/output/", d))  
d1="20190903"
d2="20190904"
dir.create(paste0("ticker/output/", d2))
foreach(sym=list.files(paste0("ticker/csv/", d2))) %do%   tryCatch({
  ggsave(
    plot=plot_sideBySide(d1, sym, d2, sym),
    filename=paste0("ticker/output/", d, "/", filename(sym), ".png"), 
    dpi=120, width=20, height=12, units="in"
  )
}, error=function(x){warning(paste0(sym, ": ", x, ")"))})



plot_sideBySide("20190903", "CK", "20190904", "CK")
plot_sideBySide("20190904", "BBL", "20190904", "SCB")
p1 = plot_ticker(load_ticker_file("20190903", filename("CK")))
p2 = plot_ticker(load_ticker_file("20190904", filename("CK")))
p1 - p2
p1 + p2 + plot_layout(ncol=2)

grid.arrange(p1, p2)
#filter
t=t %>% filter(side != "U") # remove opening auction so we can get better scale Volume

plot_ticker(t)
plot_ticker(t %>% filter(time >= hm("10:40") & hm("11:20") >= time)) # remove opening auction so we can get better scale Volume
plot_ticker(t %>% filter(time >= hm("10:28") & hm("10:30") >= time)) # remove opening auction so we can get better scale Volume
plot_ticker(t %>% filter(time >= hm("15:10") & hm("16:30") >= time)) # remove opening auction so we can get better scale Volume
ft=t %>% filter(session=="mng") # remove opening auction so we can get better scale Volume
ft=t %>% filter(session=="aft") # remove opening auction so we can get better scale Volume

plot_ticker(ft)


#only plot small Volume - to see algo or retail orders
ft=t %>% filter(qty <= 10000)
ft=t %>% filter(qty <= 1000)
#only plot big Volume - to see big market movers
ft=t %>% filter(qty >= 10000)