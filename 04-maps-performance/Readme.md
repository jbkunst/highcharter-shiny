This app show how use the highcharts map collections in an efficient way. This
is loading using JS to preloading.

```r
tags$script(src = "https://code.highcharts.com/mapdata/custom/world-robinson-highres.js")
```

Then use:

```r
mapdata <- JS("Highcharts.maps['custom/world-robinson-highres']")

highchart(type = "map") %>% 
  hc_add_series(mapData = mapdata, data = data, joinBy = c("hc-key"))
```

So this avoid sending all the _map_ (coordinates, path, etc) via the widget.