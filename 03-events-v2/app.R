library(highcharter)
library(shiny)
library(bslib)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

shinyApp(
  ui = page_fluid(
    title = "Point events demo",
    theme = app_theme,
    h2("Point events demo"),
    p("Move over or click a point to inspect the event payload."),
    layout_columns(
      col_widths = c(6, 3, 3),
      card(
        full_screen = TRUE,
        card_header("Interactive chart"),
        highchartOutput("plot_hc")
      ),
      card(
        card_header("Clicked point"),
        uiOutput("click_ui")
      ),
      card(
        card_header("Hovered point"),
        uiOutput("mouseOver_ui")
      )
    )
  ),
  server = function(input, output) {
    df <- data.frame(x = 1:5, y = 1:5, otherInfo = letters[11:15])

    output$plot_hc <- renderHighchart({
      highchart() %>%
        hc_add_series(df, "scatter") %>%
        hc_add_event_point(event = "click") %>%
        hc_add_event_point(event = "mouseOver")
    })

    observeEvent(input$plot_hc, print(paste("plot_hc", input$plot_hc)))

    output$click_ui <- renderUI({
      if (is.null(input$plot_hc_click)) {
        return(tags$p(class = "text-muted", "Click a point."))
      }

      tags$p(
        "Coordinates: ",
        tags$strong(input$plot_hc_click$x),
        ", ",
        tags$strong(input$plot_hc_click$y)
      )
    })

    output$mouseOver_ui <- renderUI({
      if (is.null(input$plot_hc_mouseOver)) {
        return(tags$p(class = "text-muted", "Move over a point."))
      }

      tags$p(
        "Coordinates: ",
        tags$strong(input$plot_hc_mouseOver$x),
        ", ",
        tags$strong(input$plot_hc_mouseOver$y)
      )
    })
  }
)
