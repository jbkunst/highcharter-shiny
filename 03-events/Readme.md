Highcharter have some helpers function to know what point is selected by the
user. 

For example, let's say you have some app with a `renderHighcharter("chart")` in
the ui. To know what point is selected you need to use `hc_add_event_point` 
and specify the event `"click"`  or `"mouseOver"`. Then is possible check 
the value using `input$chart_click` or `input$chart_mouseOver` depending the
type of event selected in `hc_add_event_point`.
