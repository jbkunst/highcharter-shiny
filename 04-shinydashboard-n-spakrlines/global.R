library(shiny)
library(bslib)
library(highcharter)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

set.seed(123)

N <- 20

x <- cumsum(rnorm(N)) + 0.5 * cumsum(runif(N))
x <- round(200 * x)

df <- data.frame(
  x = sort(as.Date(Sys.time() - lubridate::days(1:N))),
  y = abs(x)
)
