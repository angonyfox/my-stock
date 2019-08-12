#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
d=as.Date("2000-01-01")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    plotOutput("distPlot"),
    hr(),
    fluidRow(sliderInput("timeSlider", "", 
                         min=d + hms("09:45:00"),
                         max=d + hms("17:00:00"), 
                         value=d + hms("10:00:00"),
                         timeFormat="%H:%M:%S",
                         timezone="+0000",
                         width="100%",
                         step=5, #seconds
                         animate=TRUE
                         )),
    fluidRow(
        column(3,
               radioButtons("source", "Source", choices = c("rdb", "hdb"), selected = "hdb", inline=TRUE),
               dateInput("date", "Date", value = "2019-08-08"),
               selectInput("windowType", "Window", choices = c("end", "period"), selected = "period")
               ),
        column(4,
               fluidRow(
               column(6, textInput("startTime", "Start", value = "10:00:00")),
               column(6, textInput("endTime", "End", value = "00:01:00"))
               ),
               fluidRow(
                   column(2, actionButton("back", "<")),
                   column(2, actionButton("forward", ">")),
                   column(6, textInput("step", NULL, value = "00:00:30"))
               )
               )
    )
))
