#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("tq/plot.r")

tryCatch({
    hrdb = open_connection('localhost',7779) #this open a connection
}, error=function(x){
    message("rdb connection fail: ", x)
})
tryCatch({
    hhdb = open_connection('localhost',7778) #this open a connection
}, error=function(x){
    message("hdb connection fail: ", x)
})



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({
        print(input$source)
        d=gsub("-", ".", input$date)
        s=paste0("0D", input$startTime)
        e=paste0("0D", input$endTime)
        p=paste0("0D", input$period)
        wt=input$windowType
        
        if (input$source == "rdb") {
            if (wt == "end") {
                dat=load_period(s, e)
            } else {
                dat=load_period_window(d, s, p) 
            }
        } else {
            if (wt == "end") {
                dat=load_period_hdb(d, s, e)
            } else {
                dat=load_period_window_hdb(d, s, p) 
            }
        }
        plot_tqbv(dat)
    })

})
