dashboardPage(
  dashboardHeader(),
  dashboardSidebar(collapsed = TRUE),
  dashboardBody(
    fluidRow(
      valueBoxOutput("vbox"),
      valueBoxOutput("vbox2"),
      valueBoxOutput("vbox3"),
      
      box(highchartOutput("chart1")),
      box(highchartOutput("chart2"))
      
    )
  )
)