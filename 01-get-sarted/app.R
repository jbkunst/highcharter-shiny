# Load packages
library(shiny)
library(shinythemes)
library(highcharter)


# Define UI
ui <- fluidPage(
  theme = shinytheme("paper"),
  fluidRow(
    column(width = 6, ),
    column(width = 6, offset = 6),
    column(width = 6),
    column(width = 6),
    column(width = 6),
  )
               
)

# Define server function
server <- function(input, output) {
  
  
}

shinyApp(ui, server, options = list(display.mode = "showcase"))