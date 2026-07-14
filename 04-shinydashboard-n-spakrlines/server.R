shinyServer(function(input, output, session) {
  output$vbox <- renderUI({
    hc <- hchart(df, "area", hcaes(x, y), name = "Lines of code") %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())

    value_box(
      title = "LINES OF CODE WRITTEN",
      value = "1,345",
      div(HTML("&uarr;"), " 25% since last day"),
      showcase = hc,
      showcase_layout = showcase_bottom(max_height = "110px"),
      theme = value_box_theme(bg = "#47475c", fg = "#ffffff")
    )
  })

  output$vbox2 <- renderUI({
    hc <- hchart(df, "line", hcaes(x, y), name = "Distance") %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())

    value_box(
      title = "DISTANCE TRAVELED",
      value = "1,345 KM",
      div(HTML("&uarr;"), " 25% since last month"),
      showcase = hc,
      showcase_layout = showcase_bottom(max_height = "110px"),
      theme = value_box_theme(bg = "#676780", fg = "#ffffff")
    )
  })

  output$vbox3 <- renderUI({
    hc <- hchart(df, "column", hcaes(x, y), name = "Daily amount") %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())

    value_box(
      title = "THINKING TIME",
      value = "1.3 HRS.",
      div(HTML("&uarr;"), " 5% since last year"),
      showcase = hc,
      showcase_layout = showcase_bottom(max_height = "110px"),
      theme = value_box_theme(bg = "#a3edba", fg = "#313143")
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
