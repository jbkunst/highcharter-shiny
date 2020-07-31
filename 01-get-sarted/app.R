# Load packages
library(shiny)
library(shinythemes)
library(highcharter)

ui <- fluidPage(
  theme = shinytheme("paper"),
  fluidRow(
    column(width = 6, offset = 3, highchartOutput("chart1")),
    column(width = 6, offset = 3, highchartOutput("chart2")),
  )
               
)

server <- function(input, output) {
  
  output$chart1 <- renderHighchart({
    
    highcharts_demo()
    
  })
  
  output$chart2 <- renderHighchart({
    
    hchart(iris, "scatter", hcaes(Sepal.Length, Sepal.Width, group = Species))
    
  })
  
  
}

shinyApp(ui, server)