shinyUI(
  fluidPage(
    theme = shinytheme("paper"),
    tags$br(),
    fluidRow(column(4, offset = 4, selectInput("city", NULL, choices = citiesv, selectize = TRUE, width = "100%"))),
    fluidRow(
      column(7, highchartOutput("hc1", height = 600)),
      column(5, highchartOutput("hc2", height = 600))
      ),
    fluidRow(column(5, offset = 1, gsub("<p><img src=\".*\"/></p>", "", includeMarkdown("README.md"))))
    )
)
