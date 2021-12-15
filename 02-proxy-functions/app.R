library(highcharter)
library(shiny)
library(shinythemes)
library(dplyr)

langs <- getOption("highcharter.lang")

langs$loading <- "<i class='fas fa-circle-notch fa-spin fa-4x'></i>"

options(highcharter.lang = langs)

options(highcharter.theme = hc_theme_smpl())

column <- purrr::partial(shiny::column, width = 6)

ui <- fluidPage(
  theme = shinytheme("paper"),
  tags$style(HTML(".btn  { margin-bottom: 5px;}")),
  tags$hr(),
  actionButton("reset", "Reset charts", class = "btn-danger"),
  tags$hr(),
  fluidRow(
    column(
      actionButton("addpnts", "Add Series"),
      highchartOutput("hc_nd")
    ),
    column(
      actionButton("set_data", "Update all series data"),
      highchartOutput("hc_set_data")
    ),
    column(
      actionButton("mkpreds", "Add Series linkedTo existing one"),
      highchartOutput("hc_ts")
    ),
    column(
      actionButton("loading", "Loading"),
      highchartOutput("hc_ld")
    ),
    column(
      actionButton("remove", "Remove series"),
      highchartOutput("hc_rm")
    ),
    column(
      actionButton("remove_all", "Remove all series"),
      highchartOutput("hc_rm_all")
    ),
    column(
      actionButton("update1", "Update options"),
      actionButton("update2", "Update options 2"),
      highchartOutput("hc_opts")
    ),
    column(
      actionButton("update3", "Update series data"), 
      actionButton("update4", "Update series options"),
      highchartOutput("hc_opts2")
    ),
    column(
      fluidRow(
        column(radioButtons("item_choice", label = NULL, inline = TRUE, choices = c("rectangle", "parliment", "circle"))),
        column(sliderInput("item_rows", NULL, min = 0, max = 5, value = 0, step = 1, ticks = FALSE))
      ),
      highchartOutput("hc_opts3")
    ),
    column(
      actionButton("addpoint", "Add point"),
      actionButton("addpoint_w_shift", "Add point with shift"),
      actionButton("rmpoint", "Remove point"),
      highchartOutput("hc_addpoint")
    ),
    column(
      fluidRow(
        column(selectInput("selectpoint", label = NULL, choices = 1:3, selected = NULL)),
        column(actionButton("action", label = "Change"))
      ),
      highchartOutput("hc_selectpoint")
    ),
    
  )
)

server <- function(input, output, session){

# add multiples series ----------------------------------------------------
  output$hc_nd <- renderHighchart({ 
    input$reset
    
    d <- datasets::iris %>% 
      mutate(across(where(is.numeric), ~ round(.x + runif(1), 4))) %>% 
      sample_n(30) %>% 
      select(Sepal.Length, Sepal.Width)
    
    hchart(
      d, "point", 
      hcaes(x =  Sepal.Length, y = Sepal.Width),
      showInLegend = TRUE,
      name = "Random Points"
      ) %>%
      hc_title(text = "Chart with some points") 
  })
  
  observeEvent(input$addpnts, { 
    d <- datasets::iris %>% 
      mutate(across(where(is.numeric), ~ round(.x + runif(1), 4))) %>% 
      sample_n(10)
    
    highchartProxy("hc_nd") %>%
      hcpxy_add_series(
        data = d, 
        "scatter",
        hcaes(x =  Sepal.Length, y = Sepal.Width, group = Species)
      )
  })
  
  output$hc_set_data <- renderHighchart({ 
    
    input$reset
    
    df <- data.frame(
      month = month.abb,
      A = runif(12, 20, 40),
      B = runif(12, 30, 50),
      C = runif(12, 40, 60),
      D = runif(12, 50, 70)
    )
    df <- tidyr::pivot_longer(df, A:D, names_to = "name", values_to = "value")
    
    hchart(df, "column", hcaes(month, value, group = name)) %>% 
      hc_xAxis(title = list(text = "")) %>% 
      hc_yAxis(title = list(text = ""))
  })
  
  observeEvent(input$set_data, { 
    
    df <- data.frame(
      month = month.abb,
      A = runif(12, 20, 40),
      B = runif(12, 30, 50),
      C = runif(12, 40, 60),
      D = runif(12, 50, 70)
    )
    df <- tidyr::pivot_longer(df, A:D, names_to = "name", values_to = "value")
    
    highchartProxy("hc_set_data") %>%
      hcpxy_set_data(
        type = "column",
        data = df,
        mapping = hcaes(month, value, group = name),
        redraw = TRUE
      )
    
  })

# add series to linked one ------------------------------------------------
  output$hc_ts <- renderHighchart({ 
    input$reset
    hchart(AirPassengers, name = "Passengers", id = "data") 
  })
  
  observeEvent(input$mkpreds, { 
    highchartProxy("hc_ts") %>%
      hcpxy_add_series(
        forecast::forecast(AirPassengers), name = "Supermodel",
        showInLegend = FALSE, linkedTo = "data")
  })
  
# loading example ---------------------------------------------------------
  output$hc_ld <- renderHighchart({ 
    input$reset
    d <- cars %>% 
      sample_n(10) %>% 
      setNames(c("x", "y")) 
    hchart(d, "scatter", hcaes(x, y))
  })
  
  observeEvent(input$loading, {
    
    highchartProxy("hc_ld") %>%
      hcpxy_loading(action = "show")
    
    Sys.sleep(1)
    
    dat <- cars %>% 
      sample_n(10) %>% 
      setNames(c("x", "y"))
    
    highchartProxy("hc_ld") %>% 
      hcpxy_set_data(
        type = "scatter",
        data = dat,
        mapping = hcaes(x, y),
        redraw = TRUE
      )
    
    Sys.sleep(1)
    
    highchartProxy("hc_ld") %>%
      hcpxy_loading(action = "hide") %>% 
      hcpxy_update_series()
    
  })

# remove one series -------------------------------------------------------
  output$hc_rm <- renderHighchart({ 
    input$reset
    hchart(ggplot2::mpg %>% count(year, class), "column", hcaes(class, n, group = year), id = c("y1999", "y2008"))
  })
  
  observeEvent(input$remove, { 
    
    highchartProxy("hc_rm") %>%
      hcpxy_remove_series(id = "y1999")
    
  })

# remove all series -------------------------------------------------------
  output$hc_rm_all <- renderHighchart({ 
    input$reset
    hchart(
      ggplot2::mpg %>% select(displ, cty, cyl), 
      "scatter",
      hcaes(x = displ, y = cty, group = cyl)
    )
  })
  
  observeEvent(input$remove_all, { 
    
    highchartProxy("hc_rm_all") %>%
      hcpxy_remove_series(all = TRUE)
    
  })
  
# update chart options ----------------------------------------------------
  output$hc_opts <- renderHighchart({
    input$reset
    highchart() %>% 
      hc_title(text = "The first title") %>% 
      hc_add_series(data = highcharter::citytemp$london, name = "London", type = "column", colorByPoint = TRUE) %>% 
      hc_add_series(data = highcharter::citytemp$tokyo, name = "Tokio", type = "line") %>% 
      hc_xAxis(categories = highcharter::citytemp$month)
    
  })
  
  observeEvent(input$update1, { 
    
    highchartProxy("hc_opts") %>%
      hcpxy_update(
        title = list(text = "A new title"),
        chart = list(inverted = FALSE, polar = FALSE),
        xAxis = list(gridLineWidth =  1),
        yAxis = list(endOnTick = FALSE)
      )
    
  })
  
  observeEvent(input$update2, { 
    
    highchartProxy("hc_opts") %>%
      hcpxy_update(
        title = list(text = "I´m a polar chart"),
        chart = list(inverted = FALSE, polar = TRUE)
      )
    
  })
  
# update series options ---------------------------------------------------
  output$hc_opts2 <- renderHighchart({
    input$reset
    highchart() %>% 
      hc_add_series(
        data = highcharter::citytemp$london, 
        id = "london", 
        name = "London", 
        type = "column"
        # colorByPoint = TRUE
        ) %>% 
      hc_add_series(
        data = highcharter::citytemp$tokyo, 
        id = "tokyo", 
        name = "Tokyo", 
        type = "line",
        zIndex = 0
        # colorByPoint = TRUE
      ) %>% 
      hc_xAxis(categories = highcharter::citytemp$month)
    
  })
  
  observeEvent(input$update3, { 
    
    highchartProxy("hc_opts2") %>%
      hcpxy_update_series(
        id = "london",
        data = round(highcharter::citytemp$london + rnorm(12), 1)
      )
    
  })
  
  observeEvent(input$update4, { 
    
    highchartProxy("hc_opts2") %>%
      hcpxy_update_series(
        id = "london",
        type = sample(c('line', 'column', 'spline', 'area', 'areaspline', 'scatter', 'lollipop', 'bubble'), 1),
        name = paste("London ", sample(1:10, 1)),
        colorByPoint = sample(c(TRUE, FALSE), 1),
        dataLabels = list(enabled = sample(c(TRUE, FALSE), 1))
      )
    
  })
  
# update series options 3 -------------------------------------------------
  output$hc_opts3 <- renderHighchart({ 
    
    input$reset
    
    d_cut_count <- ggplot2::diamonds %>% 
      sample_n(250) %>% 
      count(cut)
    
    hchart(
      d_cut_count,
      "item", 
      hcaes(name = cut, y = n),
      name = "Cuts",
      id = "serieid"
    )
    
  })
  
  observeEvent(input$item_rows, {
    
    highchartProxy("hc_opts3") %>% 
      hcpxy_update_series(
        id = "serieid",
        rows = input$item_rows
      )
    
  })
  
  observeEvent(input$item_choice, {
    
    hcpxy <- highchartProxy("hc_opts3")
    
    if(input$item_choice == "parliment") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          center = list('50%', '88%'),
          size = '170%',
          startAngle = -100,
          endAngle = 100
        )
    } else if (input$item_choice == "rectangle") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          startAngle = NULL,
          endAngle = NULL
        )
    } else if (input$item_choice == "circle") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          center = list('50%', '50%'),
          size = '100%',
          startAngle = 0,
          endAngle = 360
        )
    }
    
  })
# add point ---------------------------------------------------------------
  output$hc_addpoint <- renderHighchart({
    input$reset
    
    df <- tibble::tibble(
      x = datetime_to_timestamp(Sys.time() - lubridate::seconds(10:1)),
      y = rnorm(length(x))
    )
    
    highchart() %>% 
      hc_xAxis(type = "datetime") %>% 
      hc_add_series(df, "line", hcaes(x, y), id = "ts", name = "A real time value") %>% 
      hc_navigator(enabled = TRUE)
    
  })
  
  observeEvent(input$addpoint, { 
    
    highchartProxy("hc_addpoint") %>%
      hcpxy_add_point(
        id = "ts",
        point = list(x = datetime_to_timestamp(Sys.time()), y = rnorm(1))
      )
    
  })
  
  observeEvent(input$addpoint_w_shift, { 
    
    highchartProxy("hc_addpoint") %>%
      hcpxy_add_point(
        id = "ts",
        point = list(x = datetime_to_timestamp(Sys.time()), y = rnorm(1)),
        shift = TRUE
      )
    
  })
  
  observeEvent(input$rmpoint, { 
    
    highchartProxy("hc_addpoint") %>%
      hcpxy_remove_point(
        id = "ts",
        i = 0
      )
    
  })
  
# mark selected point -----------------------------------------------------
  output$hc_selectpoint <- renderHighchart({
    input$reset

    hc <- highchart() %>%
      hc_add_series(
        data.frame(x = 1:3, y = sample(1:3 + 4)),
        "scatter",
        id = "seriea",
        name = "First Series",
        hcaes(x, y)
      ) %>%
      hc_add_series(
        data.frame(x = 1:3, y = sample(1:3)),
        "scatter",
        id = "serieb",
        name = "Another Series",
        hcaes(x, y)
        ) %>%
      hc_title(text = NULL)
    hc
  })

  observeEvent(input$action, {

    indx_0_based <- as.numeric(input$selectpoint) - 1
    
    highchartProxy("hc_selectpoint") %>%
      hcpxy_update_series(id = "seriea", selected = FALSE) %>% 
      hcpxy_update_point(
        id = "seriea",
        id_point = indx_0_based, 
        x = runif(1, 1, 3),
        y = runif(1, 1, 3),
        selected = sample(c(TRUE, FALSE), size = 1),
        marker = list(
          radius = sample(3:8, size = 1),
          fillColor = sample(c("yellow", "green", "red", "orange"), size = 1)
          )
        )

  })

}

shinyApp(ui, server)
