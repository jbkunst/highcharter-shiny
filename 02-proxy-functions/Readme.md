Proxy functions update an existing Highcharter widget without rebuilding the full chart.

This example covers operations such as:

- adding and removing series;
- replacing series data;
- updating chart and series options;
- adding, removing, and selecting points;
- showing and hiding the loading indicator.

Each action uses `highchartProxy()` together with an `hcpxy_*()` helper inside the Shiny server.
