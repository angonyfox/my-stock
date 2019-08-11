#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


tryCatch({
    hrdb = open_connection('localhost', 7779) #this open a connection
}, error = function(x) {
    warning("rdb connection: ", x)
})
tryCatch({
    hhdb = open_connection('localhost', 7778) #this open a connection
    print('hdb ok')
}, error = function(x) {
    warning("hdb connection: ", x)
})
source("tq/plot.r")

d = as.Date("2000-01-01")

# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {
    t <- reactiveVal(d + hm("10:00")) #current time to plot
    
    observeEvent(input$timeSlider, {
        newValue = input$timeSlider
        print(newValue)
        newValueStr = format(newValue, "%H:%M:%S")
        if (t() != newValue) {
            #t(newValue)
            updateTextInput(session, "startTime", value = newValueStr)
        }
    })
    observeEvent(input$startTime, {
        newValue = d + hms(input$startTime)
        if (t() != newValue) {
            t(newValue)
            updateSliderInput(session,
                              "time",
                              value = newValue,
                              timeFormat = "%H:%M:%S")
        }
    })
    observeEvent(input$forward, {
        newValue <- t() + hms(input$step)     # newValue <- rv$value - 1
        updateSliderInput(session,
                          "timeSlider",
                          value = newValue,
                          timeFormat = "%H:%M:%S")
    })
    observeEvent(input$back, {
        newValue <- t() - hms(input$step)     # newValue <- rv$value - 1
        updateSliderInput(session,
                          "timeSlider",
                          value = newValue,
                          timeFormat = "%H:%M:%S")
    })
    
    dataInput <- reactive({
        date = gsub("-", ".", input$date)
        s = paste0("0D", format(t(), "%H:%M:%S"))
        e = paste0("0D", input$endTime)
        wt = input$windowType
        
        if (input$source == "rdb") {
            if (wt == "end") {
                dat = load_period(s, e)
            } else {
                dat = load_period_window(d, s, e)
            }
        } else {
            if (wt == "end") {
                dat = load_period_hdb(date, s, e)
            } else {
                dat = load_period_window_hdb(date, s, e)
            }
        }
    })
    
    output$distPlot <- renderPlot({
        plot_tqbv(dataInput())
    })
    
})
