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





# create the button group for the right panel
rp_create_button_group <- function(){
  # button_groups <- dbcButtonGroup(
  #   list(
  #     dbcButton("Total", active=TRUE, id='rp_btn_total'),
  #     dbcButton("New", id='rp_btn_new')
  #   ),size = "md"
  # )
  dccRadioItems(
    id = "rp_radio_count_type",
    options=list(
      list("label"="Total", "value"="Total"),
      list("label"="New", "value"="New")
    ),
    value="Total", 
    style=radio_buttons_style
  )
}

#' generate line graphs from timeseries data
#'
#' @param timeseries_data 
#' @param chart_title 
#' @param ntype ("Total" or "New")
#'
#' @return a plotly chart object
rp_create_timeseries_chart <- function(timeseries_data,country, chart_title, ntype="Total"){

  ts_data <- timeseries_data %>% filter(type==ntype)
  p <- ggplot(ts_data) +
    aes(x = date,
        y = count,
        ) +
    geom_line() +
    scale_x_date(labels = function(x) format(x, "%m/%Y"))+
    scale_y_continuous(labels=scales::label_number_si())+
    labs(x="", y="", subtitle = country, title=chart_title)+
    theme(plot.subtitle = element_text(size=9, face="bold"))
  ggplotly(p)
}

#' create right panel component
#'
#' @return a htmlDiv component
#' @export
#'
#' @examples
#' create_right_panel


lp_create_chart<- function(daily_summary_report, chart_type){
  if (chart_type == "Confirmed")
    data <- daily_summary_report %>% rename(cases = Confirmed)
  else if (chart_type == "Active")
    data <- daily_summary_report %>% rename(cases = Active)
  else if (chart_type == "Recovered")
    data <- daily_summary_report %>% rename(cases = Recovered)
  else if (chart_type == "Death")
    data <- daily_summary_report %>% rename(cases = Deaths)

  top30 <- data %>% select(Country_Region, cases) %>%
    arrange(desc(cases)) %>%
    slice_max(cases, n = 30)

  top30 %>% 
    ggplot(aes(x = cases, y = Country_Region, fill = region)) + 
    geom_bar(stat = 'summary', fun = sum)

}

create_left_panel <- function(){
  global_total_numbers <- get_global_total_numbers()
  chart_type="Confirmed"
  c_chart <- lp_create_chart(global_total_numbers, chart_type)
  right_panel <- htmlDiv(
    list(
      dbcRow(dbcCol(htmlH1("Country"))),
      dbcRow(dbcCol(htmlDiv(
        list(
          dbcRow(dbcCol(dccDropdown(id="c_type",
                                    options=List("Confirmed", "Active", "Recovered", "Deaths")))),
          
          dbcRow(dbcCol(dccGraph(id="chart_cases_ranking", figure = c_chart))),
        )
      )))
    )
  )
  
  right_panel
}

# refresh the panel upon callbacks
rp_refresh <- function(chart_type){
  global_total_numbers <- get_global_total_numbers()
  c_chart <- lp_create_chart(global_total_numbers, chart_type)
  c_chart
}

