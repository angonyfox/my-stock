#rkdb
# remove old package
#if('qserver' %in% rownames(installed.packages())) remove.packages('qserver')
# install devtools
#
install.packages("git2r") #required
if(! 'devtools' %in% rownames(installed.packages())) install.packages('devtools')
library(devtools)
# install rkdb
devtools::install_github('kxsystems/rkdb', quiet=TRUE)

#ggplot

#devtools::install_github("hrbrmstr/slackr")
install.packages("slackr")

#install.packages("ggplot2")
#brew install libxml21

devtools::install_github("hadley/ggplot2")
install.packages("lubridate")
install.packages("gridExtra")

#for arranging plots see: https://github.com/thomasp85/patchwork
devtools::install_github("thomasp85/patchwork")