library(shiny)
library(bslib)
library(highcharter)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

ui <- page_fluid(
  title = "Getting started with Highcharter",
  theme = app_theme,
  h2("Getting started with Highcharter"),
  p("The minimal pattern for rendering Highcharter widgets in Shiny."),
  layout_columns(
    col_widths = c(6, 6),
    card(
      full_screen = TRUE,
      card_header("Highcharts demo"),
      highchartOutput("chart1")
    ),
    card(
      full_screen = TRUE,
      card_header("Iris scatter plot"),
      highchartOutput("chart2")
    )
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
