# Highcharter Shiny Examples

This repository contains small Shiny applications demonstrating Highcharter features, interactions, maps, dashboards, and time-series visualizations.

The public catalog is generated with Quarto into `docs/`.

## Repository structure

- `<app-folder>/`: one Shiny application per top-level folder.
- `<app-folder>/DESCRIPTION`: metadata used by the catalog builder.
- `<app-folder>/Readme.md`: a short technical explanation of the example.
- `<app-folder>/screenshot.png`: preview image generated when missing.
- `R/build_site.R`: builds the catalog and exports Shinylive applications.
- `index.qmd`: Quarto source for the gallery.
- `apps.yml`: generated catalog data.
- `site-build-report.json`: generated build report.
- `docs/`: generated website published with GitHub Pages.

## App metadata

Each app uses a minimal `DESCRIPTION` file:

```text
Title: App title
Description: A short technical description of the example.
Categories: shiny, interactivity, charts
```

Optional fields:

```text
Status: draft
Runtime: server
```

Apps without `Status` are included in the catalog. Apps with `Status: draft` are skipped.

Apps without `Runtime` are exported with Shinylive. Use `Runtime: server` only when an app requires a regular Shiny server.

The slug and display order are derived from the folder name.

## Build the catalog

Run from the repository root:

```r
source("R/build_site.R")
```

The script reads app metadata, exports Shinylive apps, creates missing screenshots, writes `apps.yml`, renders the Quarto site, and writes a build report.

GitHub Pages should publish from the `docs/` folder on the `master` branch.
