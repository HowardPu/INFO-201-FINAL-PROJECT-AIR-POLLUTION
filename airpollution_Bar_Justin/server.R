library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
source("script/AQICalculator.R")

# Define server logic required to draw a scatterplot
shinyServer(function(input, output) {
  output$PiePlot <- renderPlotly({
    if(input$State == "California") {
      raw.data1 <- read.csv(paste0("data/Data Sorted By State/", input$State, "1's data.csv"), stringsAsFactors = FALSE)
      raw.data2 <- read.csv(paste0("data/Data Sorted By State/", input$State, "2's data.csv"), stringsAsFactors = FALSE)
      raw.data <- rbind(raw.data1, raw.data2)
    } else {
      raw.data <- read.csv(paste0("data/Data Sorted By State/", input$State, "'s data.csv"), stringsAsFactors = FALSE)
    }
    aqi.breakpoint <- read.csv('data/Reference/aqi.breakpoints.csv')
    NO2 <- AqiCalculator(aqi.breakpoint, "NO2", mean(raw.data$NO2.Mean))
    O3 <- AqiCalculator(aqi.breakpoint, "O3", mean(raw.data$O3.Mean))
    CO <- AqiCalculator(aqi.breakpoint, "CO", mean(raw.data$CO.Mean))
    SO2 <- AqiCalculator(aqi.breakpoint, "SO2", mean(raw.data$SO2.Mean))
    name <- c("NO2", "O3", "CO", "SO2")
    value <- c(NO2, O3, CO, SO2)
    total <- round(sum(value), 3)
    result <- data.frame(value, name)
    colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)')
    # Make plot
    m <- list(
      l = 50,
      r = 50,
      b = 100,
      t = 100,
      pad = 4
    )
    plot_ly(result, labels = ~name, values = ~value, type = 'pie', textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'), hoverinfo = 'text',
            text = ~paste('Mean AQI of ', name, " in ", input$State, " is ", round(value, 3)),  marker = list(colors = colors,
            line = list(color = '#FFFFFF', width = 1)),
            showlegend = FALSE) %>%
      layout(autosize = F, width = 500, height = 500, margin = m,
        title = ~paste("Percentage of AQI of each pollutant in the given state \n (Total AQI of this state is ", total, " )"),  showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
  })
})