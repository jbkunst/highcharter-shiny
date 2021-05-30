library(shiny)
library(shinythemes)
library(highcharter)
library(dplyr)

options(highcharter.theme = hc_theme_smpl())

data(pokemon)

pokemon <- pokemon %>% 
  filter(id <= 151)

pkmn_type_color <- pokemon %>% 
  distinct(type_1, color_1)

pokemon <- pokemon %>% 
  mutate(type_1 = factor(type_1, labels = pull(pkmn_type_color, type_1)))

hc <- hchart(
  pokemon,
  "scatter",
  hcaes(x = attack, y = defense, group = type_1, name = pokemon),
  color = pull(pkmn_type_color, color_1)
  )


ui <- fluidPage(
  theme = shinytheme("paper"),
  h3("Highcharter as Shiny Inputs"),
  fluidRow(
    column(6, h4("Point Event"), highchartOutput("hcpkmn")),
    column(3, h5("MouseOver"), verbatimTextOutput("hc_1_input1")),
    column(3, h5("Click"), verbatimTextOutput("hc_1_input2"))
  ),
  fluidRow(
    column(6, h4("Series Event"), highchartOutput("hcpkmn2")),
    column(3, h5("MouseOver"), verbatimTextOutput("hc_2_input1")),
    column(3, h6("Click"), verbatimTextOutput("hc_2_input2"))
  )
)

server <-  function(input, output) {
  
  output$hcpkmn <- renderHighchart({
    
    hc %>% 
      hc_plotOptions(series = list(cursor = "pointer")) %>% 
      hc_add_event_point(event = "mouseOver") %>% 
      hc_add_event_point(event = "click")
    
  })
  
  output$hc_1_input1 <- renderPrint({ input$hcpkmn_mouseOver })
  
  output$hc_1_input2 <- renderPrint({ input$hcpkmn_click })
  
  output$hcpkmn2 <- renderHighchart({

    hc %>%
      hc_plotOptions(series = list(cursor = "pointer")) %>%
      hc_add_event_series(event = "mouseOver") %>%
      hc_add_event_series(event = "click")

  })

  output$hc_2_input1 <- renderPrint({ input$hcpkmn2_mouseOver })
  
  output$hc_2_input2 <- renderPrint({ input$hcpkmn2_click })
  
}

shinyApp(ui = ui, server = server)


