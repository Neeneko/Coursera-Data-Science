#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(rjson)
library(stringr)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    Sys.setenv(MAPBOX_TOKEN = 11122223333444)
    data = readRDS("data.rds")
    output$mapPlot <- renderPlotly({
        print(input$DataSet)
        
        
        plot <- plot_ly(data$shape_file,
                         split=~NAMELSAD10,
                         color=reformulate(input$DataSet),
                         text=~NAMELSAD10,
                         span = I(1),
                         hoveron = "fills",
                         hoverinfo = "text",
                         showlegend=FALSE,
                         source = "A",
                         key=~GEOID10) 
    })
        
    output$distPlot <- renderPlotly({
        print("render")
        click_data <- event_data("plotly_click", source = "A")
        if(is.null(click_data) == T) return(NULL)
        print(click_data$key)
        shape_row = data$shape_file[which(data$shape_file$GEOID10 == click_data$key),]
        print(shape_row)
        
        geo_idx <- which(colnames(df)=="GEOID10")
        mData <- data[[input$DataSet]][['Male']] 
        fData <- data[[input$DataSet]][['Female']] 
        
        mx   <- colnames(mData)[colnames(mData) != 'GEOID10']
        xform <- list(
            categoryorder = "array",
            categoryarray = mx
                
                        )
        
        my   <- as.numeric(mData[which(mData$GEOID10 == click_data$key),!(names(mData) %in% c('GEOID10'))])
        fy   <- as.numeric(fData[which(fData$GEOID10 == click_data$key),!(names(fData) %in% c('GEOID10'))])
        plot <- plot_ly(mData,x=mx,y=my, type = 'bar', name = 'Male',orientation = 'v')
        plot <- plot %>% add_trace(y=fy,name="Female")
        plot <- plot %>% layout(barmode = 'group',xaxis=xform)
    })

})
