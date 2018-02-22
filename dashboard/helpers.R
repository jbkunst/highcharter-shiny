hc_spark <- function(d, height = 100, suffix = "", prefix = "", type = "line", ...) {
  
  highchart() %>% 
    hc_add_series(
      zIndex = 5,
      data = list_parse2(d),
      color = 'rgba(255,255,255,0.55)',
      type = type,
      lineWidth = 2.4,
      marker = list(enabled = FALSE),
      showInLegend = FALSE,
      fillColor = list(
        linearGradient = c(0, 0, 0, 300),
        stops = list(
          list(0, 'rgba(255,255,255,0.45)'),
          list(1, 'rgba(255,255,255,0.05)')
        )
      ),
      ...
    ) %>% 
    hc_tooltip(
      zIndex = 100,
      headerFormat = "",
      pointFormat = "{point.x}: <b>{point.y}</b>",
      valueSuffix = suffix,
      valuePrefix = prefix
    ) %>% 
    hc_xAxis(visible = FALSE) %>% 
    hc_yAxis(visible = FALSE, endOnTick = FALSE, startOnTick = FALSE) %>% 
    hc_size(height = height) %>% 
    hc_chart(margins = c(0, 0, 0, 0))
  
}

valueBox2 <- function(value, subtitle, icon = NULL, color = "aqua", width = 4, href = NULL, minititle = NULL,
                      info = "Este texto te puede ayudar a entender el valor que estas viendo") {
  
  shinydashboard:::validateColor(color)
  
  if (!is.null(icon)) 
    shinydashboard:::tagAssert(icon, type = "i")
  
  boxContent <- div(
    class = paste0("small-box bg-", color),
    div(class = "inner",
        tags$small(minititle),
        tags$small(tags$i(class = "fa fa-info-circle fa-2x", title = info, class = "ttip"), class = "pull-right"),
        h3(value),
        subtitle) #, if (!is.null(icon)) div(class = "icon-large", icon)
  )
  
  if (!is.null(href)) 
    boxContent <- a(href = href, boxContent)
  div(class = if (!is.null(width)) 
    paste0("col-sm-", width), boxContent)
}