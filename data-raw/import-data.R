# Load Packages -----------------------------------------------------------

library(tidyverse)


# Import Data -------------------------------------------------------------

# read_csv("data-raw/survey_data_2021.csv") |>
#   view()

# demographics <-
#   read_csv("data-raw/survey_data_2021.csv") |>
#   select(respondent_id, location) |>
#   separate_wider_delim(
#     cols = location,
#     delim = ", ",
#     names = c("city", "state")
#   )

import_demographics_data <- function(csv_file, year) {
  read_csv(csv_file) |>
    select(respondent_id, location) |>
    separate_wider_delim(
      cols = location,
      delim = ", ",
      names = c("city", "state")
    ) |>
    mutate(survey_year = year)
}

demographics_2021 <- import_demographics_data(
  csv_file = "data-raw/survey_data_2021.csv",
  year = 2021
)
demographics_2022 <- import_demographics_data(
  csv_file = "data-raw/survey_data_2022.csv",
  year = 2022
)
demographics_2023 <- import_demographics_data(
  csv_file = "data-raw/survey_data_2023.csv",
  year = 2023
)
demographics_2024 <- import_demographics_data(
  csv_file = "data-raw/survey_data_2024.csv",
  year = 2024
)

demographics <-
  bind_rows(
    demographics_2021,
    demographics_2022,
    demographics_2023,
    demographics_2024
  )

import_favorite_parts_data <- function(csv_file, year) {
  read_csv(csv_file) |>
    select(respondent_id, favorite_parts) |>
    separate_longer_delim(
      cols = favorite_parts,
      delim = ", "
    ) |>
    mutate(survey_year = year)
}

favorite_parts_2021 <-
  import_favorite_parts_data(
    csv_file = "data-raw/survey_data_2021.csv",
    year = 2021
  )

favorite_parts_2022 <-
  import_favorite_parts_data(
    csv_file = "data-raw/survey_data_2022.csv",
    year = 2022
  )

favorite_parts_2023 <-
  import_favorite_parts_data(
    csv_file = "data-raw/survey_data_2023.csv",
    year = 2023
  )

favorite_parts_2024 <-
  import_favorite_parts_data(
    csv_file = "data-raw/survey_data_2024.csv",
    year = 2024
  )

favorite_parts <-
  bind_rows(
    favorite_parts_2021,
    favorite_parts_2022,
    favorite_parts_2023,
    favorite_parts_2024
  )

pre_post_questions <-
  read_csv("data-raw/survey_data_2022.csv") |>
  select(respondent_id, pre_question_1:post_question_2) |>
  pivot_longer(
    cols = -respondent_id
  ) |>
  separate_wider_delim(
    cols = name,
    delim = "_",
    names = c("timing", "question", "question_number")
  ) |>
  select(-question)

satisfaction_questions <-
  read_csv("data-raw/survey_data_2022.csv") |>
  select(respondent_id, contains("satisfaction")) |>
  pivot_longer(
    cols = -respondent_id
  ) |>
  separate_wider_delim(
    cols = name,
    delim = "_",
    names = c("question_type", "question", "question_number")
  ) |>
  select(-c(question_type, question))




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
