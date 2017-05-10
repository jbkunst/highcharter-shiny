shinyUI(
  fluidPage(
    theme = shinytheme("paper"),
    fluidRow(column(10, offset = 1, slider)),
    fluidRow(column(10,offset = 1, highchartOutput("hcworld"))),
    fluidRow(
      column(offset = 1, 5, highchartOutput("hcpopiramid")),
      column(5, highchartOutput("hctss"))
    ),
    fluidRow(column(5, offset = 1, gsub("<p><img src=\".*\"/></p>", "", includeMarkdown("README.md"))))
))
