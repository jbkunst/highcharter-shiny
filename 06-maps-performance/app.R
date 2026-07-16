library(shiny)
library(bslib)
library(highcharter)
library(dplyr)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

geojson <- download_map_data("custom/world-robinson-highres")

data <- get_data_from_map(geojson) %>%
  select(`hc-key`)

ui <- page_sidebar(
  title = "Map loading performance",
  theme = app_theme,
  sidebar = sidebar(
    title = "Map source",
    selectInput(
      "sel",
      "Rendering strategy",
      c("Preloaded map" = "preload", "Sending map" = "send")
    ),
    actionButton("action", "Generate map", class = "btn-primary")
  ),
  tags$script(src = "https://code.highcharts.com/mapdata/custom/world-robinson-highres.js"),
  card(
    full_screen = TRUE,
    card_header("World map"),
    highchartOutput("hcmap")
  )
)

server <- function(input, output) {
  output$hcmap <- renderHighchart({
    input$action

    data <- mutate(data, value = round(100 * runif(nrow(data)), 2))

    if (input$sel == "preload") {
      mapdata <- JS("Highcharts.maps['custom/world-robinson-highres']")
    } else {
      mapdata <- geojson
    }

    highchart(type = "map") %>%
      hc_add_series(
        mapData = mapdata,
        data = data,
        joinBy = c("hc-key"),
        borderWidth = 0
      ) %>%
      hc_chart(zoomType = "xy") %>%
      hc_colorAxis(stops = color_stops())
  })
}

shinyApp(ui, server)
