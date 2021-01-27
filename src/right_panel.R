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

source(here("src", "stylesheet.R"))

source_python(here("src", "data_model.py"))

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

create_button_group <- function(){
  button_groups <- dbcButtonGroup(
    list(
      dbcButton("Total", active=TRUE, id='rp_btn_total'),
      dbcButton("New", id='rp_btn_new')
    ),size = "md"
  )
}

# fix_date <- function(str_date){
#   c <- unlist(str_split(str_date, "/"))
#   as.Date(paste(c[1], c[2], paste0("20",c[3]), sep="/"), format="%m/%d/%Y")
# }

create_timeseries_chart <- function(timeseries_data, chart_title, ntype="Total"){

  ts_data <- timeseries_data %>% filter(type==ntype)
  # ts_data$date <- purrr::map(ts_data$date, fix_date)
  # ts_data <- ts_data %>% mutate(date = fix_date(date))
  p <- ggplot(ts_data) +
    aes(x = date,
        y = count,
        ) +
    geom_line() +
    scale_x_date(labels = function(x) format(x, "%d-%b"))+
    xlab("") + ylab("")
  ggplotly(p)
  
  # set.seed(100)
  # d <- diamonds[sample(nrow(diamonds), 1000), ]
  # 
  # p <- ggplot(data = d, aes(x = carat, y = price)) +
  #   geom_point(aes(text = paste("Clarity:", clarity)), size = 4) +
  #   geom_smooth(aes(colour = cut, fill = cut)) + facet_wrap(~ cut)
  # 
  # fig <- ggplotly(p)
  # 
  # fig
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
  country_list <- unlist(get_country_list(data_path))
  
  results <- refresh_right_panel(data_path, country, "Total")
  confirmed <- results[[1]]
  recovered <- results[[2]]
  deaths <- results[[3]]
  c_chart <- results[[4]]
  d_chart <- results[[5]]
  
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
            dbcCol(create_button_group())
          ),
          dbcRow(dbcCol(dccGraph(id="chart_confirmed_trend", figure = c_chart))),
          dbcRow(dbcCol(dccGraph(id="chart_deaths_trend", figure = d_chart)))
        )
      )))
    )
  )
  
  right_panel
}

refresh_right_panel <- function(path, country, ntype){
  summary_numbers <- unlist(get_total_numbers(path, country))
  timeseries_data <- get_timeseries_data(path, country)
  timeseries_data_confirmed <- timeseries_data[[1]]
  timeseries_data_death <- timeseries_data[[2]]
  
  c_chart = create_timeseries_chart(timeseries_data_confirmed, "Case over time", ntype=ntype)
  d_chart = create_timeseries_chart(timeseries_data_death,  "Deaths over time", ntype=ntype)
  list(summary_numbers[1], summary_numbers[2], summary_numbers[3], c_chart, d_chart)
}

