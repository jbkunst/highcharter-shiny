This app show how use the highcharts map collections in an efficient way. This
is preloading the map using the highchart predefined maps. For example
this example uses a high resolution map which is loaded one time. To do this
you need use the `tags$script(stc = link_to_map)` in your user interface 
definition.

```r
tags$script(src = "https://code.highcharts.com/mapdata/custom/world-robinson-highres.js")
```

Then, in your server:

```r
mapdata <- JS("Highcharts.maps['custom/world-robinson-highres']")

highchart(type = "map") %>% 
  hc_add_series(mapData = mapdata, data = data, joinBy = c("hc-key"))
```

You can see other predefined maps in https://code.highcharts.com/mapdata/.