source("tq/plot.r")

hrdb = open_connection('localhost',7779) #this open a connection

dat=load_window("0D00:01")
dat=load_period("0D10:44:35", "0D10:44:40")
plot_tqb(dat)
dat[["t"]]

p=ggplot()
p + geom_jitter(data=dat[["t"]], aes(x=tradeTime, y=price, color=side, size=qty, shape=side), width=0.1, height=0)
p + geom_point(data=dat[["t"]], aes(x=tradeTime, y=price, color=side, size=qty, shape=side), width=0, height=0.035)
.scale.qty=scale_size(breaks=c(25, 50, 100, 200), range=c(0.1, 15))
p
p + .scale.qty + .scale.side_col + .scale.side_shape + .scale.quote_fill + .ggplot.legend_bottom + .scale.time

dat=load_period_window("0D10:00", "0D00:10")
#bug
#this row is missing
#6 2019-08-21 10:44:37 S50U19 2019-08-21 10:44:37    U 541 1069.5
plot_tqb(dat)

plot_tqbv(load_window("0D00:00:30"))
plot_tqbv(load_window("0D00:01"))
plot_tqbv(load_window("0D00:02"))
plot_tqbv(load_window("0D00:05"))
plot_tqbv(load_window("0D00:10"))
plot_tqbv(load_window("0D00:15"))
plot_tqbv(load_window("0D00:30"))
plot_tqbv(load_window("0D02:00"))
plot_tqbv(load_window("0D04:00"))
plot_tqb(load_period("0D10:22:00", "0D10:33:00"))
plot_tqb(load_period_window("0D10:00:00", "0D00:01"))
#idea: plot bid/offer change instead of level
plot_tqbv(load_period("0D09:00", "0D14:00"))
plot_tqbv(load_period("0D09:47", "0D09:48:30"))
plot_tqbv(load_period("0D14:35:00", "0D14:40:00"))
plot_tqbv(load_period("0D10:41:00", "0D10:48:00"))
plot_tqbv(load_period("0D10:02:00", "0D10:05:00"))
plot_tqbv(load_period("0D11:42:00", "0D12:50:00"))
plot_tqbv(load_period("0D09:53:30", "0D09:54:00"))
plot_tqbv(load_period_window("0D10:44:00", "0D00:16"))
plot_tqbv(load_period_window("0D10:44:00", "0D00:00:30"))
plot_tqbv(load_period_window("0D10:45:30", "0D00:00:30"))
plot_tqbv(load_period_window("0D10:44:00", "0D00:03"))
plot_tqbv(load_period_window("0D10:45:00", "0D00:00:30"))
plot_tqbv(load_period_window("0D10:45:00", "0D00:00:30"))
plot_tqbv(load_period_window("0D12:28:00", "0D00:01"))
plot_tqbv(load_period_window("0D14:56:00", "0D00:02"))
plot_tqbv(load_period("0D15:06", "0D15:13"))
plot_tqbv(load_period("0D15:00", "0D15:06"))
plot_tqbv(load_period("0D14:55", "0D15:01"))

p=plot_tqb(load_window("0D00:01"))+ theme(legend.position="none")
ggsave(filename="live.png", plot=p, dpi=120, width=8, height=6, units="in")

#experiment
dat=load_window("0D00:01")

t=dat[["t"]]
head(t)


vol_limit=1000

p=plot_tqb(dat) + theme_bw_clean
p_ggb=ggplot_build(p)
xlim=as.POSIXct(p_ggb$layout$panel_scales_x[[1]]$range$range, origin = "1970-01-01")
ylim=p_ggb$layout$panel_scales_y[[1]]$range$range

p1=ggplot() + geom_col(data=t, aes(x=price, y=qty, fill=side), col="black") + coord_flip()
p1=p1 + .scale.side_fill + scale_x_continuous(limits=ylim) + 
  scale_y_continuous(limits=c(0, vol_limit)) 
p1=p1 + theme_bw_clean + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
p1 + geom_ras
p3=ggplot() + geom_col(data=t, aes(x=tradeTime, y=qty, fill=side), col="black")
p3=p3 + .scale.side_fill + scale_x_datetime(limits=xlim) + scale_y_continuous(limits=c(0, vol_limit))
p3=p3 + theme_bw_clean + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

p1 + p + plot_spacer() + p3 + plot_layout(widths=c(0.2, 0.8), heights=c(0.8, 0.2))



add_volume(p, dat[["t"]])
add_volume(p, dat[["t"]], vol_limit=1000)
