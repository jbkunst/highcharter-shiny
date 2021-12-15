# input <- list(country = "Cameroon", area_chart_mouseOver = list(name = "(10,20]"))

shinyServer(function(input, output) {
  
  output$area_chart <- renderHighchart(hc)
  
  output$agec_chart <- renderHighchart(hc_agec)
  
  datag <- reactive({
    
    highchartProxy("area_chart") %>%
      hcpxy_loading(action = "show")

    datag <- data_from_fips(input$country)

  })
  
  observeEvent(input$country, {
    
    datag <- datag()
    
    highchartProxy("area_chart") %>% 
      hcpxy_set_data(
        "area",
        datag,
        hcaes(x = x, y = y, group = agec), #hcaes(year, pop, group = agec),
        redraw = FALSE
        )
    
    Sys.sleep(1)
    
    highchartProxy("area_chart") %>%
      hcpxy_loading(action = "hide") %>% 
      hcpxy_redraw()
    
    
  }) 
  
  observeEvent(input$area_chart_mouseOver, {
    
    datag <- datag()
    
    print(input$area_chart_mouseOver)
    
    mouseOver_agec <- input$area_chart_mouseOver$name
    
    dagec <- datag %>% 
      filter(agec == mouseOver_agec) %>% 
      select(-agec)
    
    highchartProxy("agec_chart") %>% 
      hcpxy_update(
        subtitle = list(text = mouseOver_agec)
        ) %>%
      hcpxy_update_series(
        id = 0, 
        data = list_parse2(dagec),
        color = COLORS[[mouseOver_agec]],
        name = mouseOver_agec
        ) 
    
  })
  
})
