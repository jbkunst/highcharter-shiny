This app compares two ways of supplying map geometry to a Highcharter map.

- **Preloaded map:** the browser loads the Highcharts map collection once and the chart references it by name.
- **Transferred map:** the Shiny server sends the complete map data with the chart.

The example helps illustrate how preloading large map assets can reduce repeated data transfer.
