shinyUI(
  page_sidebar(
    title = "Population pyramid and median age",
    theme = app_theme,
    sidebar = sidebar(
      title = "Year",
      slider
    ),
    card(
      full_screen = TRUE,
      card_header("Median age by country"),
      highchartOutput("hcworld")
    ),
    layout_columns(
      col_widths = c(6, 6),
      card(
        full_screen = TRUE,
        card_header("Population pyramid"),
        highchartOutput("hcpopiramid")
      ),
      card(
        full_screen = TRUE,
        card_header("Median-age trend"),
        highchartOutput("hctss")
      )
    )
  )
)
