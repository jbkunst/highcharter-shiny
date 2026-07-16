This `bslib` example shows the minimal pattern for using Highcharter inside a Shiny application.

- `page_fluid()` and `card()` provide the responsive layout.
- `highchartOutput()` creates each chart container.
- `renderHighchart()` builds the chart on the server.
- The example combines a built-in Highcharts demo with an `iris` scatter plot.
