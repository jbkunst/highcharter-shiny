shinyUI(
  page_sidebar(
    title = "NYTimes temperature visualization",
    theme = app_theme,
    sidebar = sidebar(
      title = "City",
      selectInput(
        "city",
        "Select a city",
        choices = citiesv,
        selectize = TRUE,
        width = "100%"
      )
    ),
    layout_columns(
      col_widths = c(7, 5),
      card(
        full_screen = TRUE,
        card_header("Temperature and precipitation"),
        highchartOutput("hc1", height = 600)
      ),
      card(
        full_screen = TRUE,
        card_header("Radial weather view"),
        highchartOutput("hc2", height = 600)
      )
    )
  )
)
