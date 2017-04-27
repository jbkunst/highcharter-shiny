shinyUI(
  fluidPage(
    theme = shinytheme("paper"),
    tags$head(tags$script(src="updatehc.js")),
    tags$br(),
    fluidRow(column( 1, offset = 1, textOutput("valtoupdate"))),
    fluidRow(column(10, offset = 1, highchartOutput("hc", height = 550))),
    fluidRow(column( 5, offset = 1, gsub("<p><img src=\".*\"/></p>", "", includeMarkdown("README.md"))))
  )
)