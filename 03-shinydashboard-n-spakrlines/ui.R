dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    
    tags$p("Here are example who use highcharts in valueBoxes. In the global.R
           file the function `valueBoxSpark` is defined.")
    
  ),
  dashboardBody(
    
    tags$script(HTML(
      
      "var t = setInterval(function(){
        var resizeEvent = new Event('resize');
        window.dispatchEvent(resizeEvent);  
      }, 1000);"
      
    )),
    
    
    fluidRow(
      
      valueBoxOutput("vbox"),
      valueBoxOutput("vbox2"),
      valueBoxOutput("vbox3"),
      
      box(highchartOutput("chart1")),
      
      box(highchartOutput("chart2"))
      
    )
  )
)