# In this user interactive web page, user can use the drop down selecting list to select the 
# two charactor of the cereal that they want to see relationship on. We use the shiny library and the 
# cereal data from INFO201 class to build this web page.

library(shiny)
library(plotly)

raw.data <- read.csv('data/Data Sorted By State/state name.csv', stringsAsFactors = FALSE)
namesCol <- raw.data$State
namesCol[5]<- "California"
namesCol <- namesCol[-6]

my.ui <- navbarPage(
  
  # Application title
  "Pollutant Percentage In Each State",
  
  # Sidebar with to drop down selecting list. 
  tabPanel("PiePlot",
           sidebarLayout(
             sidebarPanel(
               selectInput("State",
                           label = h3("The State You Want To Look At"),
                           choices = namesCol)
             ),
             # Show a plot of the generated distribution
             mainPanel(
               plotlyOutput("PiePlot")
             )
           )
  )
)
# Define UI for application that draws a scatterplot.
shinyUI(my.ui)
