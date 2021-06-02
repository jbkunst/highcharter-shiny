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
  
  
  # output$vb_pop <- renderValueBox({
  #   
  #   dfip <- dfip()
  #   
  #   dfippop <- dfip %>%group_by(time) %>% summarise(pop = sum(pop))
  #   
  #   dfippopy <- filter(dfippop, time == input$year)
  #     
  #   hcspakr <- hchart(dfippop, "area", hcaes(time, pop), name = "population") %>% 
  #     hc_add_series(dfippopy, "bubble", hcaes(time, pop)) %>% 
  #     hc_add_theme(thm_spark()) %>% 
  #     hc_size(height = 100)
  #   
  #   valueBox(
  #     tagList(
  #       fmtnum(dfippopy$pop),
  #       hcspakr
  #       ),
  #     subtitle = NULL,
  #     icon = icon("chart")
  #     )
  #   
  # })
  # 
  # output$vb_pop_sel <- renderValueBox({
  #   valueBox(tagList("50"), "gola", icon("car"), color = "teal")
  # })
  # 
  # output$vb_age_avg <- renderValueBox({
  #   valueBox(tagList("50"), "gola", icon("car"), color = "teal")
  # })
  # 
  # output$vb_ratio <- renderValueBox({
  #   valueBox(tagList("50"), "gola", icon("car"), color = "teal")
  # })
  
})
