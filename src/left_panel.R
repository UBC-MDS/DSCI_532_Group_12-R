library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(reticulate)
library(here)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyverse)
library(purrr)
library(scales)
library(data.table)

source(here("src", "stylesheet.R"))
source(here("src", "data_loader.R"))




lp_create_chart <- function(daily_summary_report, c_type){
  if (c_type == "Confirmed")
    data <- daily_summary_report %>% rename(cases = Confirmed)
  else if (c_type == "Active")
    data <- daily_summary_report %>% rename(cases = Active)
  else if (c_type == "Recovered")
    data <- daily_summary_report %>% rename(cases = Recovered)
  else if (c_type == "Deaths")
    data <- daily_summary_report %>% rename(cases = Deaths)

  top30 <- data %>% select(Country_Region, cases) %>%
    arrange(desc(cases)) %>%
    slice_max(cases, n = 30)


  chart <- top30 %>% 
    ggplot(aes(x = cases, y = Country_Region, fill = cases)) + 
    geom_bar(stat = "identity") + 
    scale_fill_gradient(low = "yellow", high = "red")
  ggplotly(chart)
}

create_left_panel <- function(){
  global_total_numbers <- get_global_total_numbers()
  c_type="Confirmed"
  c_chart <- lp_create_chart(global_total_numbers, c_type)
  left_panel <- htmlDiv(
    list(
      dbcRow(dbcCol(htmlH1("Global"))),
      dbcRow(dbcCol(htmlDiv(
          list(
          dbcRow(dbcCol(dccDropdown(id="c_type",
                                    options=list(
                                              list(label = "Confirmed Cases", value = "Confirmed"),
                                              list(label = "Active Cases", value = "Active"),
                                              list(label = "Recovered Cases", value = "Recovered"),
                                              list(label = "Deaths Cases", value = "Deaths")
                                            ),
                                    value="Confirmed"
                                    )
                        )
                  ),
          dbcRow(dbcCol(dccGraph(id="chart_cases_ranking", figure = c_chart)))
              )
          ),
      )
    )
  ))
  left_panel
}

# refresh the panel upon callbacks
lp_refresh <- function(c_type){
  global_total_numbers <- get_global_total_numbers()
  c_chart <- lp_create_chart(global_total_numbers, c_type)

  c_chart
}

