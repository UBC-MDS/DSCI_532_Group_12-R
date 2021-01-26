library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(reticulate)
library(here)

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

create_timeseries_chart <- function(country, case_type=1, ntype="Total"){
  
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
  case_type <- 1
  panel_data <- get_right_panel_data(data_path, country, case_type)
  country_list <- unlist(get_country_list(data_path))
  summary_numbers <- unlist(panel_data[1][1])
  timeseries_data <- panel_data[2]
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
                create_card("Total cases", summary_numbers[1], "lb_confirmed"),
                create_card("Recovered", summary_numbers[2], "lb_recovered"),
                create_card("Deaths", summary_numbers[3], "lb_deaths")
              )
            )
          )),
          dbcRow(
            dbcCol(create_button_group())
          ),
          dbcRow(dbcCol(htmlFrame(id="chart_confirmed_trend", style=lp_chart_style))),
          dbcRow(dbcCol(htmlFrame(id="chart_deaths_trend", style=lp_chart_style)))
        )
      )))
    )
  )
  right_panel
}

