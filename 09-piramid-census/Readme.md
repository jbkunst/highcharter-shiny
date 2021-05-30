This apps show how you can use the highcharter widgets like inputs elements.
For example, clicking in a point, line, country triggers
an event, a change in an input. The app uses idbr package by [Kyle Walke](http://walkerke.github.io/).

The key parts to get this feature are:

1. Define a Javascript function to use the `Shiny.onInputChange`, the parameter 
for this functions are the name of te input to listen in the server and the
value of this input. In this example the name of the input is `hcworldinput`
and `this.name`. This last argument is a special value in highcharter to get
the name of the series or point.

2. Use the previous function  in a highcharter widget in the event that it's
required, for example, hover, click, etc.

3. Then use `input$hcworldinput` in the server side of the app.

```
fn <- "function(){
    console.log(this.name);
    Shiny.onInputChange('hcworldinput', this.name)
  }"

hc %>% 
  hc_plotOptions(
    series = list(
      cursor = "pointer", 
      point = list(
        events = list(click = JS(fn)
        )
      )
    )
  )
```