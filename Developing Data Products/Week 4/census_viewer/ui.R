#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fillPage(

    # Application title
    titlePanel("Philadelphia Census Data Viewer"),
    wellPanel(
        tags$div(tags$ul(
            tags$li("Select Dataset to display on map."),
            tags$li("Select Census Tract on Map to display Histogram"),
            tags$li("Please be patient, the map is slow to load.")),  style = "font-size: 15px")
    ),        
    fluidRow(
        column(12,wellPanel(
                       selectInput("DataSet", "Dataset:",
                                   c("Age" = "Age",
                                     "Education" = "Education")),
                   )
               )
    ),
    fluidRow(
        column(6,plotlyOutput("mapPlot")),
        column(6,plotlyOutput("distPlot")))
    )
)
