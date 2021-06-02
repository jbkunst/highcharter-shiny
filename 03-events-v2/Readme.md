Using `hc_add_event_point` and `hc_add_event_series` it is possible extract click and mouse over events from a Highchart within a Shiny app. To extract this information from the chart, `input$` variables are created as follows:

```
paste0("highchart_output", "_", "eventType")
```

In the example app below, there are two variables added to the `input$` object:

- `input$plot_hc_click`
- `input$plot_hc_mouseOver`
