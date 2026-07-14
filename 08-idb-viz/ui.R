page_sidebar(
  title = "International population explorer",
  theme = app_theme,
  sidebar = sidebar(
    title = "Country",
    selectInput(
      "country",
      "Select a country",
      choices = opts,
      selectize = TRUE,
      width = "100%"
    )
  ),
  layout_columns(
    col_widths = c(7, 5),
    card(
      full_screen = TRUE,
      card_header("Population by age group"),
      highchartOutput("area_chart")
    ),
    card(
      full_screen = TRUE,
      card_header("Selected age group"),
      highchartOutput("agec_chart")
    )
  )
)
