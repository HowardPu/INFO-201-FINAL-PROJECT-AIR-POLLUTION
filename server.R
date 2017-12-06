library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(knitr)

# Read AQI Calculator
source("script/AQICalculator.R")

shinyServer(function(input, output) {
  
  # Read the AQI breakpoint for calculating air quality index
  aqi.breakpoint <- read.csv('data/Reference/aqi.breakpoints.csv')
  
  # Render the introduction page
  output$introduction <- renderUI({
    HTML(markdown::markdownToHTML(knit('Markdown/Introduction.Rmd', quiet = TRUE)))
  })
  
  # For all data visulization, we will filter some abnomal data
  # (e.g the concentation of the air pollutant is negative)
  output$PiePlot <- renderPlotly({
    
    # Read the data 
    # Since we cannot upload file larger than 100 mb, and the data for California is greater than 100 mb
    # we separate the data for California in two smaller pieces
    if(input$State == "California") {
      raw.data1 <- read.csv(paste0("data/Data Sorted By State/", input$State, "1's data.csv"), stringsAsFactors = FALSE)
      raw.data2 <- read.csv(paste0("data/Data Sorted By State/", input$State, "2's data.csv"), stringsAsFactors = FALSE)
      raw.data <- rbind(raw.data1, raw.data2)
    } else {
      raw.data <- read.csv(paste0("data/Data Sorted By State/", input$State, "'s data.csv"), stringsAsFactors = FALSE)
    }
    
    # gather the AQI index for each pollutant
    NO2 <- AqiCalculator(aqi.breakpoint, "NO2", mean(raw.data$NO2.Mean))
    O3 <- AqiCalculator(aqi.breakpoint, "O3", mean(raw.data$O3.Mean))
    CO <- AqiCalculator(aqi.breakpoint, "CO", mean(raw.data$CO.Mean))
    SO2 <- AqiCalculator(aqi.breakpoint, "SO2", mean(raw.data$SO2.Mean))
    
    name <- c("NO2", "O3", "CO", "SO2")
    value <- c(NO2, O3, CO, SO2)
    total <- round(sum(value), 3)
    result <- data.frame(value, name)
    
    # set the color of each pollutant in the pie chart
    colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)')
    
    # Make Pie chart
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
            text = ~paste0(" AQI of ", name, " is ", round(value, 3)),  marker = list(colors = colors,
            line = list(color = '#FFFFFF', width = 1)),
            showlegend = FALSE) %>%
      layout(autosize = F, width = 500, height = 500, margin = m,
             title = ~paste0("Percentage of AQI of each pollutant in ", input$State, " <br /> (Total AQI : ", total, " )"),  
             showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$scatter <- renderPlot({
    
    # Read the data of user's interest
    data <- read.csv(paste0("data/Data Sorted By Year/", input$Year.Scatter,"'s data.csv"), stringsAsFactors = FALSE)
    
    # Get column names based on user's input
    get.x <- paste0(input$xAxis, ".Mean")
    get.y <- paste0(input$yAxis, ".Mean")
    
    # Get the unit of each pollutant
    get.x.unit <- data[, paste0(input$xAxis, ".Units")] [1]
    get.y.unit <- data[, paste0(input$yAxis, ".Units")] [1]
    
    # Get revalent data
    filtered.data <- select_(data, get.x, get.y) %>%
      filter_(paste0(get.x, ">=0&", get.y, ">=0")) %>%
      group_by_(get.x, get.y) %>%
      summarise(number = n()) %>%
      filter_(paste0(get.x, "!=0|", get.y, "!=0"))
    
    # Plot the scatter plot
    ggplot(data = filtered.data) + 
      geom_point(mapping = aes_string(x = get.x, y = get.y)) + 
      labs(x = paste0("First pollutant : ", input$xAxis, " (", get.x.unit, ")"),
           y = paste0("Second pollutant : ", input$yAxis, " (", get.y.unit, ")"), 
           title = paste0(input$xAxis, " against ", input$yAxis, " in ", input$Year.Scatter))
  })
  
  output$map <- renderPlotly({
    
    # Read the data of user's interest
    data <- read.csv(paste0("data/Data Sorted By Year/", input$Year.Map,"'s data.csv"), stringsAsFactors = FALSE)
    
    # Get the AQI index of each state in each year
    # it also includes the overall AQI (highest AQI in SO2, NO2, O3, and CO)
    air.data <- group_by(data, State) %>%
      summarize(NO2.Mean = max(0, mean(NO2.Mean)), O3.Mean = max(0, mean(O3.Mean)), 
                SO2.Mean = max(0, mean(SO2.Mean)), CO.Mean = max(0, mean(CO.Mean))) %>%
      mutate(`NO2 AQI` = round(AqiCalculatorWithList(aqi.breakpoint, "NO2", NO2.Mean), digits = 3),
             `O3 AQI` = round(AqiCalculatorWithList(aqi.breakpoint, "O3", O3.Mean), digits = 3),
             `SO2 AQI` = round(AqiCalculatorWithList(aqi.breakpoint, "SO2", SO2.Mean), digits = 3),
             `CO AQI` = round(AqiCalculatorWithList(aqi.breakpoint, "CO", CO.Mean), digits = 3)) %>%
      mutate(`Overall AQI` = case_when(`NO2 AQI` >= `O3 AQI` & `NO2 AQI` >= `SO2 AQI` & `NO2 AQI` >= `CO AQI` ~ `NO2 AQI`,
                                       `O3 AQI` >= `NO2 AQI` & `O3 AQI` >=  `SO2 AQI` & `O3 AQI` >= `CO AQI` ~ `O3 AQI`,
                                       `SO2 AQI` >= `NO2 AQI` & `SO2 AQI` >= `O3 AQI` & `SO2 AQI` >= `CO AQI` ~ `SO2 AQI`,
                                       `CO AQI` >= `NO2 AQI` &   `CO AQI` >= `O3 AQI` & `CO AQI` >= `SO2 AQI`  ~ `CO AQI`))
    
    
    # add the hover information of each state and states' name abbrivation
    air.data <- mutate(air.data, hover.info = paste(paste0("State : ", air.data$State), 
                                                    paste0("Overall AQI : ", air.data$`Overall AQI`),
                                                    paste0("NO2 AQI : ", air.data$`NO2 AQI`),
                                                    paste0("SO2 AQI : ", air.data$`SO2 AQI`),
                                                    paste0("Ozone AQI : ", air.data$`O3 AQI`),
                                                    paste0("CO AQI : ", air.data$`CO AQI`), sep = "<br />"),
                       state.code = state.abb[match(State,state.name)]) 
    
    # set District Of Columbia's abbr "DC" to prevent N/A
    air.data[air.data$State == "District Of Columbia", "state.code"] <- "DC"
    
    # set the color of the map
    # lowest AQI --> highest AQI
    # green     ---> red
    map.color <- c('#1a9850', '#66bd63', '#a6d96a', '#d9ef8b', '#ffffbf', '#fee08b', '#fdae61', '#f46d43', '#d73027')
    
    # Draw the US map, color is based on the overall AQI
    # Deeper color means higher overall AQI
    l <- list(color = toRGB("white"), width = 2)
    
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    
    m <- list(
      l = 50,
      r = 50,
      b = 300,
      t = 40,
      pad = 100
    )
    p <- plot_geo(air.data, locationmode = 'USA-states') %>%
      add_trace(
        # evaluate this string as column name
        z = ~eval(parse(text = paste0("air.data$`", input$AQI.selection, "`"))),
        text = ~hover.info,
        locations = ~state.code,
        hoverinfo = "text",
        colors = map.color,
        # evaluate this string as column name
        color = ~eval(parse(text = paste0("air.data$`", input$AQI.selection, "`")))
      ) %>% colorbar(title = input$AQI.selection, len = 0.8) %>%
      layout(
        autosize = F, width = 600, height = 600, margin = m,
        showlegend = TRUE,
        title = paste0('US Air Pollution Map in ', input$Year.Map, 
                       " <br /> ", "(White means state's data is unavailable in ", input$Year.Map, ")"),
        geo = g
      )
  })
  
  output$barPlot <- renderPlot({
    
    # Read the data of user's interest
    # change the month in the form of integer into words in abbrivation
    # summarize the data based on each pollutants
    data <- read.csv(paste0("data/Data Sorted By Year/", input$Year.Bar,"'s data.csv"), stringsAsFactors = FALSE)
    data <- mutate(data, Month = month.abb[as.integer(format(as.Date(Date.Local), "%m"))])
    air.data <- group_by(data, Month) %>%
                summarise(NO2.Mean = mean(NO2.Mean), O3.Mean = mean(O3.Mean), CO.Mean = mean(CO.Mean), SO2.Mean = mean(SO2.Mean)) %>%
                mutate(NO2 = AqiCalculatorWithList(aqi.breakpoint, "NO2", NO2.Mean), 
                       O3 = AqiCalculatorWithList(aqi.breakpoint, "O3", O3.Mean), 
                       CO = AqiCalculatorWithList(aqi.breakpoint, "CO", CO.Mean), 
                       SO2 = AqiCalculatorWithList(aqi.breakpoint, "SO2", SO2.Mean))
    
    # Find the pollutants of user's interest
    # if user selects nothing, it will produce no plot instead of generating error
    if(length(input$Pollutant) >= 1) {
      
      # customize the columns of data to suit for bar plot (especially for "fill")
      # order month in words abbrivation into the order based on integer
      # if we do not do this, month will be ordered alphabetically
      list.of.interest <- c("Month", input$Pollutant)
      present.data <- air.data[, list.of.interest]
      present.data <- gather(present.data, Pollutant, AQI, -Month)
      present.data$Month <- factor(present.data$Month, levels = month.abb)
      
      # draw the bar plot
      plot <- ggplot(data = present.data, aes(Month, AQI))
      
      # separate the bar if user want to separate the bar
      if(input$Split) {
        plot <- plot + geom_bar(stat = "identity", aes(fill = Pollutant), position = "dodge")
      } else {
        plot <- plot + geom_bar(stat = "identity", aes(fill = Pollutant)) 
      }
      plot + labs(title = paste0('The US AQI distribution in ', input$Year.Bar,
                                 " (Separate by pollutants)"))
    } 
  })
  
  # Render Q&A session
  output$q.and.a <- renderUI({
    HTML(markdown::markdownToHTML(knit('Markdown/Q&A.Rmd', quiet = TRUE)))
  })
  
  # Render the group member page
  output$group.member <- renderUI({
    HTML(markdown::markdownToHTML(knit('Markdown/GroupMember.Rmd', quiet = TRUE)))
  })
})