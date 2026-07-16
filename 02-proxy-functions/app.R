library(highcharter)
library(shiny)
library(bslib)
library(dplyr)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

langs <- getOption("highcharter.lang")
langs$loading <- "<i class='fas fa-circle-notch fa-spin fa-4x'></i>"
options(highcharter.lang = langs)
options(highcharter.theme = hc_theme_smpl())

source("server.R", local = TRUE)

ui <- page_fluid(
  title = "Highcharter proxy functions",
  theme = app_theme,
  div(
    class = "d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3",
    div(
      h2(class = "mb-1", "Highcharter proxy functions"),
      p(class = "text-muted mb-0", "Update charts without rebuilding the widget.")
    ),
    actionButton("reset", "Reset charts", class = "btn-danger")
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      full_screen = TRUE,
      card_header("Add series"),
      actionButton("addpnts", "Add series", class = "btn-primary mb-2"),
      highchartOutput("hc_nd")
    ),
    card(
      full_screen = TRUE,
      card_header("Replace series data"),
      actionButton("set_data", "Update all series data", class = "btn-primary mb-2"),
      highchartOutput("hc_set_data")
    ),
    card(
      full_screen = TRUE,
      card_header("Linked series"),
      actionButton("mkpreds", "Add linked forecast", class = "btn-primary mb-2"),
      highchartOutput("hc_ts")
    ),
    card(
      full_screen = TRUE,
      card_header("Loading state"),
      actionButton("loading", "Show loading update", class = "btn-primary mb-2"),
      highchartOutput("hc_ld")
    ),
    card(
      full_screen = TRUE,
      card_header("Remove one series"),
      actionButton("remove", "Remove series", class = "btn-primary mb-2"),
      highchartOutput("hc_rm")
    ),
    card(
      full_screen = TRUE,
      card_header("Remove all series"),
      actionButton("remove_all", "Remove all series", class = "btn-primary mb-2"),
      highchartOutput("hc_rm_all")
    ),
    card(
      full_screen = TRUE,
      card_header("Update chart options"),
      div(
        class = "d-flex flex-wrap gap-2 mb-2",
        actionButton("update1", "Update options"),
        actionButton("update2", "Make polar")
      ),
      highchartOutput("hc_opts")
    ),
    card(
      full_screen = TRUE,
      card_header("Update series options"),
      div(
        class = "d-flex flex-wrap gap-2 mb-2",
        actionButton("update3", "Update data"),
        actionButton("update4", "Update appearance")
      ),
      highchartOutput("hc_opts2")
    ),
    card(
      full_screen = TRUE,
      card_header("Item series layout"),
      layout_columns(
        col_widths = c(7, 5),
        radioButtons(
          "item_choice",
          "Shape",
          inline = TRUE,
          choices = c("rectangle", "parliment", "circle")
        ),
        sliderInput(
          "item_rows",
          "Rows",
          min = 0,
          max = 5,
          value = 0,
          step = 1,
          ticks = FALSE
        )
      ),
      highchartOutput("hc_opts3")
    ),
    card(
      full_screen = TRUE,
      card_header("Add and remove points"),
      div(
        class = "d-flex flex-wrap gap-2 mb-2",
        actionButton("addpoint", "Add point"),
        actionButton("addpoint_w_shift", "Add with shift"),
        actionButton("rmpoint", "Remove point")
      ),
      highchartOutput("hc_addpoint")
    ),
    card(
      full_screen = TRUE,
      card_header("Update a selected point"),
      layout_columns(
        col_widths = c(8, 4),
        selectInput("selectpoint", "Point", choices = 1:3, selected = NULL),
        actionButton("action", "Change", class = "btn-primary mt-4")
      ),
      highchartOutput("hc_selectpoint")
    )
  )
)

shinyApp(ui, server)
