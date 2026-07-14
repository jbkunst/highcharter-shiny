library(shiny)
library(bslib)
library(highcharter)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  success = "#a3edba"
)

ui <- fluidPage(
  theme = app_theme,
  fluidRow(
    column(width = 6, highchartOutput("chart1")),
    column(width = 6, highchartOutput("chart2"))
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
