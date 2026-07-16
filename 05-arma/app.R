library(shiny)
library(bslib)
library(highcharter)
library(stats)

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

LAG_MAX  <- 10
STR_OBS  <- 20
NOBS     <- 5000
AR       <- 0.75
MA       <- 0.20
SEED     <- 123
DURATION <- 100 # needs to be <= than min refresh interval

set.seed(SEED)

ts_aux <- arima.sim(model = list(ar = AR, ma = MA), n = STR_OBS)

teoACF <- as.numeric(ARMAacf(ar = AR, ma = MA, lag.max = LAG_MAX, pacf = FALSE))
smpACF <- as.numeric(acf(ts_aux, lag.max = LAG_MAX, plot = FALSE)$acf)

hc_afc <- highchart() %>%
  hc_chart(type = "column") %>%
  hc_yAxis(min = -1, max = 1) %>%
  hc_add_series(data = smpACF, id = "sacf", name = "Estimated", color = "#428bca") %>%
  hc_add_series(data = teoACF, id = "tacf", name = "Theoretical") %>%
  hc_tooltip(
    table = TRUE,
    headerFormat = "<small>Lag {point.key}</small><table>",
    valueDecimals = 3
  ) %>%
  hc_plotOptions(
    series = list(
      pointWidth = 5,
      animation = list(duration = DURATION),
      marker = list(symbol = "circle")
    )
  )

hc_afc

ui <- page_sidebar(
  title = "ARMA process simulation",
  theme = app_theme,
  sidebar = sidebar(
    title = "Simulation controls",
    sliderInput("ar", "AR", -.9, .9, value = AR, 0.05, width = "100%"),
    sliderInput("ma", "MA", -.9, .9, value = MA, 0.05, width = "100%"),
    sliderInput(
      "interval",
      "Refresh (seconds)",
      0.5,
      2,
      value = 1,
      step = 0.5,
      width = "100%"
    ),
    card(
      card_header("Current model"),
      uiOutput("model")
    )
  ),
  layout_columns(
    col_widths = c(8, 4),
    card(
      full_screen = TRUE,
      card_header("Simulated time series"),
      highchartOutput("ts")
    ),
    card(
      full_screen = TRUE,
      card_header("Autocorrelation"),
      highchartOutput("acf")
    )
  )
)

server <- function(input, output, session) {
  value <- reactiveVal(STR_OBS)

  ts <- reactive({
    value(STR_OBS)

    set.seed(SEED)
    ts <- arima.sim(model = list(ar = input$ar, ma = input$ma), n = NOBS)
  })

  output$model <- renderUI({
    arp <- ifelse(input$ar != 0, paste0(input$ar, " \\times X_{t-1}"), "")
    map <- ifelse(input$ma != 0, paste0(" + ", input$ma, " \\times \\epsilon_{t-1}"), "")

    mod <- paste0("X_{t} = ", arp, ifelse(input$ar != 0, " + ", ""), "\\epsilon_t", map)
    mod <- paste0("$$", mod, "$$")

    tags$p(withMathJax(mod))
  })

  output$ts <- renderHighchart({
    ts <- ts()

    df <- data.frame(x = 1:STR_OBS, y = head(ts, STR_OBS))

    hchart(
      df,
      "line",
      id = "ts",
      color = "#428bca",
      name = "Time series",
      marker = list(enabled = FALSE),
      animation = list(duration = DURATION),
      tooltip = list(valueDecimals = 3)
    ) %>%
      hc_navigator(
        enabled = TRUE,
        series = list(type = "line"),
        xAxis = list(labels = list(enabled = FALSE))
      ) %>%
      hc_yAxis_multiples(
        list(title = list(text = "")),
        list(
          title = list(text = ""),
          linkedTo = 0,
          opposite = TRUE,
          tickPositioner = JS("function(min,max){
                                 var data = this.chart.yAxis[0].series[0].processedYData;
                                 return [Math.round(1000 * data[data.length-1])/1000];
                              }")
        )
      )
  })

  output$acf <- renderHighchart({
    hc_afc
  })

  observeEvent(ts(), {
    ts <- ts()

    teoACF <- as.numeric(ARMAacf(ar = input$ar, ma = input$ma, lag.max = LAG_MAX, pacf = FALSE))
    smpACF <- as.numeric(acf(head(ts, STR_OBS), lag.max = LAG_MAX, plot = FALSE)$acf)

    highchartProxy("acf") %>%
      hcpxy_update_series(id = "tacf", data = teoACF) %>%
      hcpxy_update_series(id = "sacf", data = smpACF)
  })

  observe({
    interval <- max(as.numeric(input$interval), 0.25)

    invalidateLater(1000 * interval, session)

    animation <- TRUE
    value_to_add <- isolate(value()) + 1

    value(value_to_add)

    ts <- ts()

    smpACF <- as.numeric(acf(head(ts, value_to_add), lag.max = LAG_MAX, plot = FALSE)$acf)

    highchartProxy("acf") %>%
      hcpxy_update_series(id = "sacf", data = smpACF)

    highchartProxy("ts") %>%
      hcpxy_add_point(
        id = "ts",
        point = list(x = value_to_add, y = ts[value_to_add]),
        animation = animation
      )
  })
}

shinyApp(ui = ui, server = server)
