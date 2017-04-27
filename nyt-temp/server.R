# input  <- list(city = sample(citiesv, 1))
shinyServer(function(input, output) {
  
  data <- reactive({
    
    url_file <- file.path(url_base, "assets", sprintf("%s.csv", input$city))
    
    # url_file <- "http://graphics8.nytimes.com/newsgraphics/2016/01/01/weather/assets/new-york_ny.csv"
    message(url_file)
    
    data <- read_csv(url_file) %>% 
      mutate(dt = datetime_to_timestamp(date)) 
    
    data
    
  })
  
  temps <- reactive({
    
    data <- data()
    
    dtempgather <- data %>% 
      select(dt, date, starts_with("temp")) %>% 
      select(-temp_rec_high, -temp_rec_low) %>% 
      rename(temp_actual_max = temp_max,
             temp_actual_min = temp_min) %>% 
      gather(key, value, -date, -dt) %>% 
      mutate(key = str_replace(key, "temp_", ""),
             value = as.numeric(value)) 
    
    dtempspread <- dtempgather %>% 
      separate(key, c("serie", "type"), sep = "_") %>% 
      spread(type, value) %>% 
      filter(!is.na(max) | !is.na(min))
    
    temps <- dtempspread %>% 
      mutate(serie = factor(serie, levels = c("rec", "avg", "actual")),
             serie = fct_recode(serie, Record = "rec", Normal = "avg", Observed = "actual"))
    
    temps
    
  })
  
  records <- reactive({
    
    data <- data()
    
    records <- data %>%
      select(dt, date, temp_rec_high, temp_rec_low) %>% 
      filter(temp_rec_high != "NULL" | temp_rec_low != "NULL") %>% 
      dmap_if(is.character, str_extract, "\\d+") %>% 
      dmap_if(is.character, as.numeric) %>% 
      gather(type, value, -date, -dt) %>% 
      filter(!is.na(value)) %>% 
      mutate(type = str_replace(type, "temp_rec_", ""),
             type = paste("This year record", type))
    
    records
    
  })
  
  precip_day <- reactive({
    
    data <- data()
    
    precip_day <- data %>% 
      mutate(temp_day = temp_min + (temp_max - temp_min)/2) %>% 
      select(date, dt, temp_day, month, precip_value) %>% 
      group_by(month) %>% 
      mutate(precip_day = c(0, diff(precip_value))) %>% 
      ungroup() %>% 
      filter(precip_day > 0 | row_number() == 1 | row_number() == n()) 
    
    precip_day 
    
  })
  
  precip <- reactive({
    
    data <- data()
    
    precip <- select(data, dt, date, precip_value, month)
    
    precip
    
  })
  
  precipnormal <- reactive({
    
    data <- data()
    
    precipnormal <- data %>%
      select(date, dt, precip_normal, month) %>%
      group_by(month) %>%
      filter(row_number() %in% c(1, n())) %>%
      ungroup() %>%
      fill(precip_normal)
    
    precipnormal
    
  })
  
  output$hc1 <- renderHighchart({
    
    temps <- temps()
    records <- records()
    precip <- precip()
    precipnormal <- precipnormal()
    precip_day <- precip_day()
    
    hc <- highchart() %>%
      hc_xAxis(type = "datetime", showLastLabel = FALSE,
               dateTimeLabelFormats = list(month = "%B")) %>% 
      hc_tooltip(shared = TRUE, useHTML = TRUE,
                 headerFormat = as.character(tags$small("{point.x: %b %d}", tags$br()))) %>% 
      hc_plotOptions(series = list(borderWidth = 0, pointWidth = 4))
    
    colors <- c("#ECEBE3", "#C8B8B9", "#A90048")
    colors <- colors[which(levels(temps$serie) %in% unique(temps$serie))]
    
    hc <- hc %>% 
      hc_add_series(temps, type = "columnrange",
                    hcaes(dt, low = min, high = max, group = serie),
                    color = colors) 
    
    if(nrow(records) > 0) {
      
      pointsyles <- list(
        symbol = "circle",
        lineWidth= 1,
        radius= 4,
        fillColor= "#FFFFFF",
        lineColor= NULL
      )
      
      hc <- hc %>% 
        hc_add_series(records, "point", hcaes(x = dt, y = value, group = type),
                      marker = pointsyles)
    }
    
    axis <- create_yaxis(
      naxis = 2,
      heights = c(3,1),
      sep = 0.05,
      turnopposite = FALSE,
      showLastLabel = FALSE,
      startOnTick = FALSE)
    
    axis[[1]]$title <- list(text = "Temperature")
    axis[[1]]$labels <- list(format = "{value}°F")
    
    axis[[2]]$title <- list(text = "Precipitation")
    axis[[2]]$min <- 0
    
    hc <- hc_yAxis_multiples(hc, axis)
    
    hc <- hc %>%
      hc_add_series(precip, type = "area", hcaes(dt, precip_value, group = month),
                    name = "Precipitation", color = "#008ED0", lineWidth = 1,
                    yAxis = 1, fillColor = "#EBEAE2", 
                    id = c("p", rep(NA, 11)), linkedTo = c(NA, rep("p", 11))) %>% 
      hc_add_series(precipnormal, "line", hcaes(x = dt, y = precip_normal, group = month),
                    name = "Normal Precipitation", color = "#008ED0", yAxis = 1,
                    id = c("np", rep(NA, 11)), linkedTo = c(NA, rep("np", 11)),
                    lineWidth = 1)
    
    hc
    
  })
  
  output$hc2 <- renderHighchart({
    
    temps <- temps()
    precip_day <- precip_day()
    
    temps1 <- filter(temps, serie == "Observed")
    temps2 <- filter(temps, serie != "Observed")
    
    colors <- c("#ECEBE3", "#C8B8B9")
    colors <- colors[which(levels(temps2$serie) %in% unique(temps2$serie))]
    colors <- hex_to_rgba(colors, 0.9)
    
    hchart(temps2, "columnrange",  hcaes(date, low = min, high = max, group = serie),
           color = colors) %>% 
      hc_add_series(temps1, "columnrange",  hcaes(date, low = min, high = max, color = max),
                    name = "Observed", color = "#FCAF13") %>% 
      hc_add_series(precip_day, "line", hcaes(dt, y = temp_day, size = precip_day),
                    name = "precipitation", 
                    zIndex = 4, color = hex_to_rgba("#008ED0", 0.2), lineWidth = 0,
                    marker = list(radius = 8)) %>% 
      hc_chart(polar = TRUE) %>% 
      hc_plotOptions(series = list(borderWidth = 0, pointWidth = 0.01)) %>%
      hc_yAxis(endOnTick = FALSE, showFirstLabel = FALSE, showLastLabel = FALSE) %>% 
      hc_xAxis(type = "datetime", showLastLabel = FALSE,
               dateTimeLabelFormats = list(month = "%B")) %>% 
      hc_tooltip(shared = TRUE, useHTML = TRUE,
                 headerFormat = as.character(tags$small("{point.x: %b %d}", tags$br()))) 
      
  })
  
})
