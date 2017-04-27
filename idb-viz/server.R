input <- list(fip = "US", year = 2010)
shinyServer(function(input, output) {
  
  dfip <- reactive({
    dfip <- filter(data, fips ==input$fip)
    dfip
  })
   
  output$input <- renderPrint({ as.list(input) })
  
  output$hc_area <- renderHighchart({
    dfip <- dfip()
    
    brks <- seq(0, 100, length.out = 10 + 1)
    
    datag <- dfip %>% 
      mutate(agec = cut(age, breaks = brks, include.lowest = TRUE)) %>% 
      group_by(name = name, fip = fips, year = time, agec) %>% 
      summarise(pop = sum(pop),
                age_median = round(median(age))) %>% 
      ungroup() %>% 
      arrange(desc(age_median)) %>% 
      mutate(birth_year = year - age_median,
             agec = fct_inorder(agec))
    
    
    colors <- inferno(length(brks) - 1, begin = 0.1, end = .9) %>% 
      hex_to_rgba() %>%
      rev()
    
    hchart(datag, "area", hcaes(year, pop, group = agec),
           color = colors, showInLegend = FALSE) %>% 
      # hc_tooltip(crosshairs = TRUE) %>% 
      hc_xAxis(crosshair = list(color = "yellow", label = list(enabled = TRUE, format = "{value}"))) %>% 
      hc_yAxis(crosshair = list(label = list(enabled = TRUE, format = "{value:,.0f}"))) %>% 
      hc_plotOptions(
        series = list(
          lineColor = "white",
          lineWidth = 0.5,
          stacking = "normal",
          marker = list(symbol = "circle", size = 0.1, enabled = FALSE, lineWidth = 0)
        )
      )
    
  })
  
  output$vb_pop <- renderValueBox({
    dfip <- dfip()
    dfippop <- dfip %>%group_by(time) %>% summarise(pop = sum(pop))
    dfippopy <- filter(dfippop, time == input$year)
      
    hcspakr <- hchart(dfippop, "area", hcaes(time, pop), name = "population") %>% 
      hc_add_series(dfippopy, "bubble", hcaes(time, pop)) %>% 
      hc_add_theme(thm_spark()) %>% 
      hc_size(height = 100)
    
    valueBox(
      tagList(
        fmtnum(dfippopy$pop),
        hcspakr
        ),
      subtitle = NULL,
      icon = icon("chart")
      )
    
  })
  
  output$vb_pop_sel <- renderValueBox({
    valueBox(tagList("50"), "gola", icon("car"), color = "teal")
  })
  
  output$vb_age_avg <- renderValueBox({
    valueBox(tagList("50"), "gola", icon("car"), color = "teal")
  })
  
  output$vb_ratio <- renderValueBox({
    valueBox(tagList("50"), "gola", icon("car"), color = "teal")
  })
  
})
