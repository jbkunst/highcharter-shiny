library(dplyr)
library(purrr)
library(stringr)
library(tibble)
library(fs)
library(glue)
library(yaml)
library(jsonlite)
library(cli)

value <- function(desc, name, default = "") {
  x <- desc[[name]]
  if (is.null(x) || is.na(x) || !nzchar(x)) x <- default

  x |>
    str_replace_all("[\r\n\t]+", " ") |>
    str_squish()
}

as_csv <- function(x) {
  x <- str_squish(x)
  if (!nzchar(x)) return(character())

  x |>
    str_split(",") |>
    pluck(1) |>
    str_squish() |>
    discard(~ !nzchar(.x))
}

folder_order <- function(x) {
  order <- str_extract(x, "^[0-9]+")
  if_else(is.na(order), Inf, as.numeric(order))
}

screenshot_path <- function(app, slug) {
  screenshot <- path(app, "screenshot.png")

  if (!file_exists(screenshot)) {
    tryCatch(
      webshot2::appshot(
        app,
        file = screenshot,
        delay = 10,
        vwidth = 1440,
        vheight = 900
      ),
      error = function(e) {
        cli::cli_alert_warning("{app}: screenshot failed: {conditionMessage(e)}")
      }
    )
  }

  image <- "site-assets/placeholder.svg"

  if (file_exists(screenshot)) {
    image <- path("site-assets", "screenshots", paste0(slug, ".png"))
    file_copy(screenshot, image, overwrite = TRUE)
  }

  chartr("\\", "/", image)
}

export_shinylive <- function(meta) {
  tryCatch(
    {
      shinylive::export(
        meta$app,
        "docs/live",
        subdir = meta$slug,
        template_params = list(title = meta$title)
      )

      list(status = "exported", message = "Shinylive export completed.")
    },
    error = function(e) {
      list(status = "failed", message = conditionMessage(e))
    }
  )
}

cli::cli_h1("Setup")

if (file_exists("apps.yml")) file_delete("apps.yml")
if (dir_exists("docs")) dir_delete("docs")

dir_create(c("site-assets/screenshots", "docs/live"))
writeLines("", "docs/.nojekyll", useBytes = TRUE)

cli::cli_h1("Read app metadata")

app_dirs <- dir() |>
  keep(~ dir_exists(.x)) |>
  keep(~ file_exists(path(.x, "DESCRIPTION"))) |>
  discard(~ .x %in% c("docs", "site-assets")) |>
  discard(~ startsWith(.x, "."))

apps <- map_dfr(app_dirs, function(app) {
  desc <- read.dcf(path(app, "DESCRIPTION"))
  desc <- as.list(desc[1, , drop = TRUE])

  tibble(
    app = app,
    slug = app,
    order = folder_order(app),
    title = value(desc, "Title"),
    description = value(desc, "Description"),
    categories = list(as_csv(value(desc, "Categories"))),
    runtime = str_to_lower(value(desc, "Runtime", "shinylive")),
    status = str_to_lower(value(desc, "Status"))
  )
}) |>
  arrange(.data$order, .data$app)

draft_apps <- apps |>
  filter(.data$status == "draft")

apps <- apps |>
  filter(.data$status != "draft")

if (nrow(apps) == 0) {
  stop("No app DESCRIPTION files found.", call. = FALSE)
}

metadata_errors <- apps |>
  mutate(
    missing = pmap_chr(
      list(.data$title, .data$description, .data$categories, .data$runtime),
      function(title, description, categories, runtime) {
        fields <- c(
          if (!nzchar(title)) "Title",
          if (!nzchar(description)) "Description",
          if (length(categories) == 0) "Categories",
          if (!runtime %in% c("shinylive", "server")) "Runtime"
        )

        paste(fields, collapse = ", ")
      }
    )
  ) |>
  filter(nzchar(.data$missing))

if (nrow(metadata_errors) > 0) {
  stop(
    paste(
      glue("{metadata_errors$app}: missing or invalid {metadata_errors$missing}"),
      collapse = "\n"
    ),
    call. = FALSE
  )
}

cli::cli_h1("Export Shinylive apps")

shinylive_apps <- apps |>
  filter(.data$runtime == "shinylive")

server_apps <- apps |>
  filter(.data$runtime == "server")

shinylive_results <- shinylive_apps$app |>
  set_names() |>
  map(function(app) {
    meta <- shinylive_apps |>
      filter(.data$app == .env$app) |>
      slice(1)

    export_shinylive(meta)
  })

shinylive_ok <- names(keep(shinylive_results, ~ .x$status == "exported"))
shinylive_failed <- names(discard(shinylive_results, ~ .x$status == "exported"))

walk(shinylive_failed, function(app) {
  cli::cli_alert_warning('App "{app}": {shinylive_results[[app]]$message}')
})

cli::cli_h1("Generate catalog")

cards <- shinylive_ok |>
  map(function(app) {
    meta <- shinylive_apps |>
      filter(.data$app == .env$app) |>
      slice(1)

    list(
      title = meta$title,
      description = meta$description,
      image = screenshot_path(meta$app, meta$slug),
      categories = meta$categories[[1]],
      path = as.character(glue("live/{meta$slug}/index.html"))
    )
  }) |>
  set_names(shinylive_ok)

write_yaml(unname(cards), "apps.yml")

quarto::quarto_render(".", quarto_args = "--no-clean")

report_apps <- apps |>
  transmute(
    slug = .data$slug,
    runtime = .data$runtime,
    result = case_when(
      .data$app %in% shinylive_ok ~ "shinylive",
      .data$app %in% shinylive_failed ~ "shinylive_failed",
      .data$app %in% server_apps$app ~ "server",
      TRUE ~ "none"
    ),
    message = map_chr(.data$app, function(app) {
      if (!app %in% names(shinylive_results)) return("Runtime is not shinylive.")
      shinylive_results[[app]]$message
    })
  )

build_report <- list(
  app_count = nrow(apps),
  draft_apps = draft_apps$app,
  shinylive_ok = shinylive_ok,
  shinylive_failed = shinylive_failed,
  server_apps = server_apps$app,
  apps = report_apps
)

write_json(
  build_report,
  "site-build-report.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
write_json(
  build_report,
  "docs/build-report.json",
  pretty = TRUE,
  auto_unbox = TRUE
)

cli::cli_h1("Done")
message("Wrote apps.yml")
message("Wrote site-build-report.json")
message("Rendered Quarto site to docs/")
