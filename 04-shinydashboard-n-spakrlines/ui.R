page_fluid(
  title = "Highcharter sparklines in value boxes",
  theme = app_theme,
  h2("Highcharter sparklines in value boxes"),
  p("Compact charts embedded in modern bslib value boxes."),
  layout_columns(
    col_widths = c(4, 4, 4),
    uiOutput("vbox"),
    uiOutput("vbox2"),
    uiOutput("vbox3")
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      full_screen = TRUE,
      card_header("Highcharter theme"),
      highchartOutput("chart1")
    ),
    card(
      full_screen = TRUE,
      card_header("Simple theme"),
      highchartOutput("chart2")
    )
  )
)
