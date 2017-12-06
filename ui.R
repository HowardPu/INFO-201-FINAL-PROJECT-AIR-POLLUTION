library(shiny)
library(plotly)

# Read all states
state <- read.csv('Index/state name.csv', stringsAsFactors = FALSE)
all.state <- state$State

# Read all years
year <- read.csv('Index/year.csv', stringsAsFactors = FALSE)
all.year <- year$Year



# Terms: AQI represents air quaility index, which is an index such that we can compare the impact of each air
#        pollutant without the limit of units (for example: 1 ppm O3 may not have the same impact as 1 ppm NO2)

shinyUI(navbarPage(
  
  # Application title
  "Air Pollution Statistics in the US",
  
  # Introduction page of this application
  tabPanel("Introduction", mainPanel(uiOutput("introduction"))),
  
  # UI for Pie Chart Page 
  tabPanel("Pie Chart",
           sidebarLayout(
             sidebarPanel(
               # select the state of user's interest
               selectInput("State",
                           label = "The State of your interest",
                           choices = all.state), width = 3), 
             
             # draw the pie chart corresponding to user's interest
             # Especially useful for comparing airpollution within a state
             # (E.g : which pollutant contributes the most to air pollution in given state?)
             mainPanel(plotlyOutput("PiePlot")))),
  
  # UI for Map page
  tabPanel("Map",
           sidebarLayout(
             sidebarPanel(
               # choose the year of the interest
               selectInput("Year.Map", 
                           label = "Select the year of your interest", 
                           choices = all.year),
               
               # Choose the preferred comparason AQI
               selectInput('AQI.selection', label = 'Select the AQI of your interest',
                           choices = list("Overall AQI" = "Overall AQI", "SO2 AQI" = "SO2 AQI", 
                                          "CO AQI" = "CO AQI", "O3 AQI" = "O3 AQI", "NO2 AQI" = "NO2 AQI")), width = 3),
             
           # Draw the US air pollution map based on user's year of interest (Calculated by AQI)
           # Especially useful for comparing air pollution across states
           mainPanel(plotlyOutput("map")))),
  
  # UI for Scatter Plot
  tabPanel("Scatter", 
           sidebarLayout(
             sidebarPanel(
               # choose the year of user's interest
               selectInput("Year.Scatter", label = "Select the year of your interest", choices = all.year),
               
               # choose the first air pollutant(x axis)
               selectInput("xAxis", label = "The first pollutant of your interest",
                                    choices = list("Sulfur Dioxide (SO2)" = "SO2", "Carbon Monoxide (CO)" = "CO", 
                                                   "Ozone (O3)" = "O3", "Nitrogen Dioxide (NO2)" = "NO2"), selected = 1),
               
               # choose the second air pollutant(y axis)
               selectInput("yAxis", label = "The second pollutant of your interest",
                                    choices = list("Sulfur Dioxide (SO2)" = "SO2", "Carbon Monoxide (CO)" = "CO", 
                                                   "Ozone (O3)" = "O3", "Nitrogen Dioxide (NO2)" = "NO2"), selected = 1)),
             
           # Draw the scatter plot which x axis is the first pollutant and y axis is the second pollutant at given year
           # Especially useful for comparing correlation between two air pollutants
           mainPanel(plotOutput("scatter")))),
  
  # UI for Barplot
  tabPanel("Barplot", 
           sidebarLayout(
             sidebarPanel(
               # choose the pollutants that will be drawn in the bar plot
               checkboxGroupInput("Pollutant", label = "Select all pollutants of your interest", 
                                               choices = list("Sulfur Dioxide (SO2)" = "SO2", 
                                                              "Carbon monoxide (CO)" = "CO", 
                                                              "Nitrogen Dioxide (NO2)" = "NO2", 
                                                              "Ozone (O3)" = "O3"), 
                                               selected = c("SO2", "CO", "NO2", "O3")), 
               
               # Select the year of interest
               selectInput("Year.Bar", label = "Select the year of your interest", choices = all.year),
               
               # select whether the user want to separate the bars of different pollutants
               checkboxInput("Split", label = "Separate the bar", value = FALSE)),
          
          # draw the barplot of change of air pollutant (calculated by AQI) against each month at given year
          # Especiall useful for comparing the trend of pollutant based on change of time
          mainPanel(plotOutput("barPlot")))),
  
  # Q&A session of this application
  tabPanel("Q&A", mainPanel(uiOutput("q.and.a"))),
  
  # Intro for group mambers
  tabPanel("Group Members", mainPanel(uiOutput("group.member")))
))
