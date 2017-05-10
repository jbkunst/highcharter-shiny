library(shiny)
library(purrr)
library(dplyr)
library(rlist)
library(highcharter)
library(viridisLite)
library(shinythemes)

load("dataappmin.RData")
# data("worldgeojson")

options(highcharter.theme = hc_theme_smpl())
options(shiny.launch.browser = TRUE)

input <- list(yr = sample(yrs, size = 1), hcworldinput = "Canada")

slider <- sliderInput(
  "yr",
  NULL,
  value = min(yrs),
  min = min(yrs),
  max = max(yrs),
  round = TRUE,
  ticks = FALSE,
  step = 1,
  width = "100%",
  animate = animationOptions(interval = 1000)
)