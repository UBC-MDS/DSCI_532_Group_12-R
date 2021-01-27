library(reticulate)
library(here)
library(tidyverse)
source_python(here("src", "data_model.py"))

data_path = paste0(here(), "/data/raw")
processed_data_path = paste0(here(), "/data/processed/")

#--------Refresh data if outdated----------------
reload_all_data(data_path)

# --------Load the data frames--------------------
daily_report <-
  read_csv(paste0(processed_data_path, file_daily_report))

timeseries_confirmed <- read_csv(paste0(processed_data_path, file_timeseries_confirmed))
timeseries_death <- read_csv(paste0(processed_data_path, file_timeseries_death))
timeseries_recovered <- read_csv(paste0(processed_data_path, file_timeseries_recovered))

# ---------Define functions to use in UI----------

#' get summary numbers for a country
#'
#' @return a tibble of Confirmed, Deaths, Recovered, Active
get_total_numbers_by_country <- function(country) {
  daily_report %>% filter(Country_Region == country) %>% summarise(
    Confirmed = sum(Confirmed),
    Deaths = sum(Deaths),
    Recovered = sum(Recovered)
  )
}

# return a list of unique countries
get_country_list <- function()
{
  unique(daily_report$Country_Region)
}

#' get timeseries data by country and case type
#'
#' @param country 
#' @param casetype (Confirmed: 1, Deaths: 2, Recovered: 3)
#'
#' @return a tibble with 2 columns: date, count, type (Total/New)
get_timeseries_data_by_country <- function(country, casetype) {
  if (casetype == 1)
    df <- timeseries_confirmed
  else if (casetype == 2)
    df <- timeseries_death
  else
    df <- timeseries_recovered
  country_data <- df %>% filter(`Country/Region` == country)
  country_data <- country_data[, 7:ncol(country_data)]
  country_data <-
    country_data %>%
    summarise_all(list(sum)) %>%
    pivot_longer(colnames(country_data),
                 names_to = "date",
                 values_to = "Total")
  country_data <- country_data %>% mutate(yesterday = Total)
  country_data$yesterday <- shift(country_data$yesterday,
                                  fill = 0,
                                  type = c("lag"))
  country_data <-
    country_data %>% mutate(New = Total - yesterday) %>%
    separate(col = date,
             into = c("month", "day", "year"),
             sep = "/") %>%
    mutate(date = as.Date(paste(month, day, paste0("20", year), sep = '/'), tryFormats =
             c("%m/%d/%Y"))) %>%
    select(date, Total, New) %>%
    pivot_longer(
      cols = c("Total", "New"),
      names_to = "type",
      values_to = "count"
    )
  country_data
}
