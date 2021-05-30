shinyServer(function(input, output, session) {
  
  output$vbox <- renderValueBox({
    
    hc <- hchart(df, "area", hcaes(x, y), name = "lines of code")  %>% 
      hc_size(height = 100) %>% 
      hc_credits(enabled = FALSE) %>% 
      hc_add_theme(hc_theme_sparkline_vb()) 
    
    valueBoxSpark(
      value = "1,345",
      title = toupper("Lines of code written"),
      sparkobj = hc,
      subtitle = tagList(HTML("&uarr;"), "25% Since last day"),
      info = "This is the lines of code I've written in the past 20 days! That's a lot, right?",
      icon = icon("code"),
      width = 4,
      color = "teal",
      href = NULL
    )
    
    
  })
  
  output$vbox2 <- renderValueBox({
    
    hc2 <- hchart(df, "line", hcaes(x, y), name = "Distance")  %>% 
      hc_size(height = 100) %>% 
      hc_credits(enabled = FALSE) %>% 
      hc_add_theme(hc_theme_sparkline_vb()) 
    
    valueBoxSpark(
      value = "1,345 KM",
      title = toupper("Distance Traveled"),
      sparkobj = hc2,
      subtitle = tagList(HTML("&uarr;"), "25% Since last month"),
      info = "This is the lines of code I've written in the past 20 days! That's a lot, right?",
      icon = icon("plane"),
      width = 4,
      color = "red",
      href = NULL
    )
    
  })
  
  output$vbox3 <- renderValueBox({
    
    hc3 <- hchart(df, "column", hcaes(x, y), name = "Daily amount")  %>% 
      hc_size(height = 100) %>% 
      hc_credits(enabled = FALSE) %>% 
      hc_add_theme(hc_theme_sparkline_vb())
    
    valueBoxSpark(
      value = "1,3 Hrs.",
      title = toupper("Thinking time"),
      sparkobj = hc3,
      subtitle = tagList(HTML("&uarr;"), "5% Since last year"),
      info = "This is the lines of code I've written in the past 20 days! That's a lot, right?",
      icon = icon("hourglass-half"),
      width = 4,
      color = "yellow",
      href = NULL
    )
    
    
  })
  
  output$chart1 <- renderHighchart({
    
    highcharts_demo() %>% 
      hc_add_theme(hc_theme_hcrt())
    
  })
  
  output$chart2 <- renderHighchart({
    
    highcharts_demo() %>% 
      hc_add_theme(hc_theme_smpl())
    
  })
  
})