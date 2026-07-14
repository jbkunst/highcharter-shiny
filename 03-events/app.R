library(shiny)
library(bslib)
library(highcharter)
library(dplyr)

options(highcharter.theme = hc_theme_smpl())

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

data(pokemon)

pokemon <- pokemon %>%
  filter(id <= 151)

pkmn_type_color <- pokemon %>%
  distinct(type_1, color_1)

scales::show_col(pkmn_type_color$color_1, borders = FALSE)

pokemon <- pokemon %>%
  mutate(type_1 = factor(type_1, levels = pull(pkmn_type_color, type_1))) %>%
  select(id, pokemon, attack, defense, type_1)

pokemon

hc <- hchart(
  pokemon,
  "scatter",
  hcaes(x = attack, y = defense, group = type_1, name = pokemon),
  color = pull(pkmn_type_color, color_1)
)

hc

ui <- page_fluid(
  title = "Highcharter events as Shiny inputs",
  theme = app_theme,
  h2("Highcharter events as Shiny inputs"),
  p("Move over or click the charts to inspect point and series event payloads."),
  card(
    full_screen = TRUE,
    card_header("Point events"),
    layout_columns(
      col_widths = c(6, 3, 3),
      highchartOutput("hcpkmn"),
      card(
        card_header("Mouse over"),
        verbatimTextOutput("hc_1_input1")
      ),
      card(
        card_header("Click"),
        verbatimTextOutput("hc_1_input2")
      )
    )
  ),
  card(
    full_screen = TRUE,
    card_header("Series events"),
    layout_columns(
      col_widths = c(6, 3, 3),
      highchartOutput("hcpkmn2"),
      card(
        card_header("Mouse over"),
        verbatimTextOutput("hc_2_input1")
      ),
      card(
        card_header("Click"),
        verbatimTextOutput("hc_2_input2")
      )
    )
  )
)

server <- function(input, output) {
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
