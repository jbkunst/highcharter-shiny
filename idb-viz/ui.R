dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
    fluidRow(
      column(
        4, offset = 4,
        selectInput("fip", NULL, choices = opts, selectize = TRUE, width = "100%"),
        selectInput("year", NULL, choices = 1990:2050, selectize = TRUE, width = "100%")
        )
      ),
    fluidRow(
      column(
        7,
        highchartOutput("hc_area")
        ),
      column(
        5,
        column(
          12,
          valueBoxOutput("vb_pop", width = 12),
          valueBoxOutput("vb_pop_sel", width = 12),
          valueBoxOutput("vb_age_avg", width = 12),
          valueBoxOutput("vb_ratio", width = 12)
          )
        )
      ),
    fluidRow(
      column(5, verbatimTextOutput("input")),
      column(5, offset = 1, gsub("<p><img src=\".*\"/></p>", "", includeMarkdown("README.md")))
      )
  )
)