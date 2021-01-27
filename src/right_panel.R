library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(reticulate)
library(here)
library(ggplot2)
library(plotly)
library(tidyverse)
library(purrr)
library(scales)
library(data.table)

source(here("src", "stylesheet.R"))
source(here("src", "data_loader.R"))


#' generate a list of country options to use in dropdown list
#'
#' @param country_list 
#'
#' @return a list of list (label=country, value=country)
#' @export
#'
#' @examples
#' country_list <- c("Canada", "Vietnam")
#' create_country_options(country_list)
create_country_options <- function(country_list){
  options <- list()
  for (i in seq_along(country_list)){
    options <- append(options, list(list(label=country_list[i], value=country_list[i])))
  }
  options
}

# create a dbcCard component
create_card <- function(title, card_content, content_id){
  card <- dbcCard(
    dbcCardBody(
      list(
        htmlH5(title, style = card_title),
        htmlP(card_content, style=card_text, id=content_id)
      )
    )
  )
}

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
create_right_panel <- function(){
  data_path = paste0(here(), "/data/raw")
  country = "Canada"
  country_list <- get_country_list()
  total_numbers <- get_total_numbers_by_country(country)
  confirmed <- comma(total_numbers$Confirmed)
  recovered <- comma(total_numbers$Recovered)
  deaths <- comma(total_numbers$Deaths)
  timeseries_confirmed <- get_timeseries_data_by_country(country, 1)
  timeseries_death <- get_timeseries_data_by_country(country, 2)
  c_chart <- rp_create_timeseries_chart(timeseries_confirmed, country, "Cases over time")
  d_chart <- rp_create_timeseries_chart(timeseries_death, country, "Deaths over time")
  
  right_panel <- htmlDiv(
    list(
      dbcRow(dbcCol(htmlH1("Country"))),
      dbcRow(dbcCol(htmlDiv(
        list(
          dbcRow(dbcCol(dccDropdown(id="dd_country",
                                    options=create_country_options(country_list), value="Canada"))),
          dbcRow(dbcCol(
            dbcCardDeck(
              list(
                create_card("Total cases", confirmed, "lb_confirmed"),
                create_card("Recovered", recovered, "lb_recovered"),
                create_card("Deaths", deaths, "lb_deaths")
              )
            )
          )),
          dbcRow(
            dbcCol(rp_create_button_group())
          ),
          dbcRow(dbcCol(dccGraph(id="chart_confirmed_trend", figure = c_chart))),
          dbcRow(dbcCol(dccGraph(id="chart_deaths_trend", figure = d_chart)))
        )
      )))
    )
  )
  
  right_panel
}

# refresh the panel upon callbacks
rp_refresh <- function(country, ntype){
  total_numbers <- get_total_numbers_by_country(country)
  confirmed <- comma(total_numbers$Confirmed)
  recovered <- comma(total_numbers$Recovered)
  deaths <- comma(total_numbers$Deaths)
  timeseries_confirmed <- get_timeseries_data_by_country(country, 1)
  timeseries_death <- get_timeseries_data_by_country(country, 2)
  c_chart <- rp_create_timeseries_chart(timeseries_confirmed, country, "Cases over time", ntype)
  d_chart <- rp_create_timeseries_chart(timeseries_death, country, "Deaths over time", ntype)
  
  list(confirmed, recovered, deaths, c_chart, d_chart)
}

