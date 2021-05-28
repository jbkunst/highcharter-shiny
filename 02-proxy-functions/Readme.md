Proxy functions allow you modify the highcharter widget without redraw
the entire chart.

The functions implemented are:

- `hcpxy_add_series` To add a new series to an existing highcharter widget.
- `hcpxy_remove_series` Remove specific series of a highcharter widget.
- `hcpxy_update` Change general chart options of a widget.
- `hcpxy_update_series` Change series options of a widget.
- `hcpxy_add_point` To add a specific point from a specific series.
- `hcpxy_remove_point` To remove a specific point from a specific series.
- `hcpxy_loading` To enable or disable the the loading icon over the widget.

To use this function you need a widget in your `ui`, let's say:

```r
ui <- fluidPage(
  ...,
  highchartOutput("widget"),
  ...
  )
```

If you need to modify the widget associated to `highchartOutput("widget")`
you need to create a proxy object indicating the id, in this case `"widget"`.
It's important to use the argument `session` to define the server.

```r
server <- function(input, output, session){

  # some where in you server, probably in a observeEvent
  
  observeEvent(input$idbutton, { 
  
    highchartProxy("widget") %>%
      # modify options
      hcpxy_update(
        title = list(text = "A new title"),
        chart = list(inverted = FALSE, polar = FALSE),
        xAxis = list(gridLineWidth =  1),
        yAxis = list(endOnTick = FALSE),
        chart = list(inverted = FALSE, polar = TRUE)
      ) %>% 
      # add data
      hc_add_series(df, "line", hcaes(x, y), id = "ts", name = "A real time value")
  })     
 
}
```

Don't forget to check the code example.