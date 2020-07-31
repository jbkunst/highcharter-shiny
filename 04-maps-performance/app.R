library(shiny)
library(shinythemes)
library(highcharter)
library(dplyr)

geojson <- download_map_data("custom/world-robinson-highres")

data <- get_data_from_map(geojson) %>% 
  select(`hc-key`)

ui <- fluidPage(
  theme = shinytheme("paper"),
  tags$script(src = "https://code.highcharts.com/mapdata/custom/world-robinson-highres.js"),
  fluidRow(
    tags$hr(),
    column(
      12,
      selectInput("sel", NULL, c("Preloaded map" = "preload", "Sending map" = "send")),
      actionButton("action", "Generate map")
    ),
    tags$hr(),
    column(12, highchartOutput("hcmap"))
  )
)

server <- function(input, output) {
  
  output$hcmap <- renderHighchart({
    
    input$action
    
    data <- mutate(data, value = round(100 * runif(nrow(data)), 2))
    
    if(input$sel == "preload") {
      mapdata <- JS("Highcharts.maps['custom/world-robinson-highres']")
    } else {
      mapdata <- geojson
    }
    
    highchart(type = "map") %>% 
      hc_add_series(mapData = mapdata, data = data, joinBy = c("hc-key"),
                    borderWidth = 0) %>% 
      hc_colorAxis(stops = color_stops())
    
  })
  
}

shinyApp(ui, server)