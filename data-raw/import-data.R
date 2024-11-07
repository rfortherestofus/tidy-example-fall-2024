# Load Packages -----------------------------------------------------------

library(tidyverse)
library(fs)

# Create vector of CSVs ---------------------------------------------------

csv_files <-
  dir_ls(
    path = "data-raw",
    regexp = "csv"
  )

# Import Data -------------------------------------------------------------

import_demographics_data <- function(csv_file) {
  read_csv(csv_file) |>
    select(respondent_id, location) |>
    separate_wider_delim(
      cols = location,
      delim = ", ",
      names = c("city", "state")
    ) |>
    mutate(survey_year = csv_file) |>
    mutate(survey_year = str_remove(survey_year, "data-raw/survey_data_")) |>
    mutate(survey_year = str_remove(survey_year, ".csv")) |>
    mutate(survey_year = as.numeric(survey_year))
}

demographics_data <-
  map(csv_files, import_demographics_data) |>
  bind_rows()

demographics_data |> 
  write_rds("data/demographics_data.rds")

import_favorite_parts_data <- function(csv_file) {
  read_csv(csv_file) |>
    select(respondent_id, favorite_parts) |>
    separate_longer_delim(
      cols = favorite_parts,
      delim = ", "
    ) |>
    rename(favorite_part = favorite_parts) |>
    mutate(survey_year = csv_file) |>
    mutate(survey_year = str_remove(survey_year, "data-raw/survey_data_")) |>
    mutate(survey_year = str_remove(survey_year, ".csv")) |>
    mutate(survey_year = as.numeric(survey_year))
}

favorite_parts_data <-
  map(csv_files, import_favorite_parts_data) |>
  bind_rows()

favorite_parts_data |> 
  write_rds("data/favorite_parts_data.rds")

import_pre_post_data <- function(csv_file) {
  read_csv(csv_file) |>
    select(respondent_id, pre_question_1:post_question_2) |>
    pivot_longer(
      cols = -respondent_id
    ) |>
    separate_wider_delim(
      cols = name,
      delim = "_",
      names = c("timing", "question", "question_number")
    ) |>
    select(-question) |>
    mutate(survey_year = csv_file) |>
    mutate(survey_year = str_remove(survey_year, "data-raw/survey_data_")) |>
    mutate(survey_year = str_remove(survey_year, ".csv")) |>
    mutate(survey_year = as.numeric(survey_year))
}

pre_post_data <-
  map(csv_files, import_pre_post_data) |>
  bind_rows()

pre_post_data |> 
  write_rds("data/pre_post_data.rds")

import_satisfaction_data <- function(csv_file) {
  
    read_csv(csv_file) |>
    select(respondent_id, contains("satisfaction")) |>
    pivot_longer(
      cols = -respondent_id
    ) |>
    separate_wider_delim(
      cols = name,
      delim = "_",
      names = c("question_type", "question", "question_number")
    ) |>
    select(-c(question_type, question)) |> 
    mutate(survey_year = csv_file) |>
    mutate(survey_year = str_remove(survey_year, "data-raw/survey_data_")) |>
    mutate(survey_year = str_remove(survey_year, ".csv")) |>
    mutate(survey_year = as.numeric(survey_year))
}

satisfaction_data <-
  map(csv_files, import_satisfaction_data) |>
  bind_rows()

satisfaction_data |> 
  write_rds("data/satisfaction_data.rds")

# Examples ----------------------------------------------------------------

# satisfaction_questions |>
#   group_by(question_number) |>
#   summarize(mean_response = mean(value, na.rm = TRUE))

# favorite_parts |>
#   left_join(
#     demographics,
#     join_by(respondent_id)
#   ) |>
#   filter(city == "Portland") |>
#   count(favorite_parts)
