shinyServer(function(input, output, session) {
  
  newvalue <- reactive({
    invalidateLater(1000)
    newvalue <- runif(1)
    # message(sprintf("New value at %s is %s", Sys.time(), newvalue))
    newvalue
  })
  
  output$valtoupdate <- renderText({
    newvalue()
  })
  
  output$hc <- renderHighchart({
    
    hc <- data.frame(time = datetime_to_timestamp(Sys.time()), value = 0) %>% 
      hchart("line", hcaes(time, value)) %>% 
      hc_xAxis(type = "datetime") 
    
    hc$x$type <- "stock"
    
    hc
    
  })
  
})