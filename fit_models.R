library(tidyverse)
library(brms)
library(posterior)

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/summaries", recursive = TRUE, showWarnings = FALSE)

site_df <- readr::read_csv("data/site_df.csv", show_col_types = FALSE) |>
  mutate(
    site_id = factor(site_id),
    region = factor(region, levels = c("North", "South", "Central", "West"))
  )

survey_df <- readr::read_csv("data/survey_df.csv", show_col_types = FALSE) |>
  mutate(
    site_id = factor(site_id),
    survey_id = factor(survey_id),
    region = factor(region, levels = c("North", "South", "Central", "West")),
    sensor_type = factor(sensor_type, levels = c("basic", "advanced"))
  )

site_naive_df <- readr::read_csv("data/site_naive_df.csv", show_col_types = FALSE) |>
  mutate(
    site_id = factor(site_id),
    region = factor(region, levels = c("North", "South", "Central", "West"))
  )

naive_priors <- c(
  prior(normal(0, 1.5), class = "Intercept"),
  prior(normal(0, 1), class = "b")
)

occurrence_priors <- c(
  prior(normal(0, 1.5), class = "Intercept"),
  prior(normal(0, 1), class = "b"),
  prior(exponential(1), class = "sd")
)

detection_priors <- c(
  prior(normal(0, 1.5), class = "Intercept"),
  prior(normal(0, 1), class = "b")
)

naive_fit <- brm(
  ever_detected ~ site_age_z,
  data = site_naive_df,
  family = bernoulli(link = "logit"),
  prior = naive_priors,
  chains = 4, iter = 2000, warmup = 1000,
  seed = 222
)

occurrence_fit <- brm(
  true_event ~ site_age_z + (1 | region),
  data = site_df,
  family = bernoulli(link = "logit"),
  prior = occurrence_priors,
  chains = 4, iter = 2000, warmup = 1000,
  seed = 222
)

detection_fit <- brm(
  detected ~ cloud_cover_z + sensor_advanced,
  data = survey_df |> filter(true_event == 1),
  family = bernoulli(link = "logit"),
  prior = detection_priors,
  chains = 4, iter = 2000, warmup = 1000,
  seed = 222
)

saveRDS(naive_fit, "outputs/models/naive_fit.rds")
saveRDS(occurrence_fit, "outputs/models/occurrence_fit.rds")
saveRDS(detection_fit, "outputs/models/detection_fit.rds")
