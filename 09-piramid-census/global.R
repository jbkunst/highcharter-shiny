library(shiny)
library(bslib)
library(purrr)
library(dplyr)
library(rlist)
library(highcharter)
library(viridisLite)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

load("dataappmin.RData")
# data("worldgeojson")

options(highcharter.theme = hc_theme_smpl())

input <- list(yr = sample(yrs, size = 1), hcworldinput = "Canada")

slider <- sliderInput(
  "yr",
  "Year",
  value = min(yrs),
  min = min(yrs),
  max = max(yrs),
  round = TRUE,
  ticks = FALSE,
  step = 1,
  width = "100%",
  animate = animationOptions(interval = 1000)
)
