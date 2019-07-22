.scale.qty=scale_size(breaks=c(25, 50, 100, 200), limits=c(1, 200), range=c(0.5, 15))
.scale.side_col=scale_colour_manual(values=c("B" = "darkgreen", "S" = "darkred", "U" = "blue", "NS"="grey"))
.scale.side_shape=scale_shape_manual(values=c("B" = 2, "S" = 6, "U" = 1, "NS"=0))

.scale.quote_fill=scale_fill_gradient(low="#fff2bd", high="#383200", breaks=c(20, 50, 100, 200), limits=c(1, 200))
.scale.time=scale_x_datetime(date_labels="%H:%M:%S")

