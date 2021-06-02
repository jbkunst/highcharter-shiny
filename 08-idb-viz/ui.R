dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
    fluidRow(
      column(
        width = 4,
        offset = 4,
        selectInput("country", NULL, choices = opts, selectize = TRUE, width = "100%"),
        )
      ),
    fluidRow(
      column(
        width = 7,
        highchartOutput("area_chart")
        ),
      column(
        5,
        column(
          12,
          highchartOutput("agec_chart")
          # valueBoxOutput("vb_pop_sel", width = 12),
          # valueBoxOutput("vb_age_avg", width = 12),
          # valueBoxOutput("vb_ratio", width = 12)
          )
        )
      )
  )
)