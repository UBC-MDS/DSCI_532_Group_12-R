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
library(maps)
library(viridis)

source(here("src", "stylesheet.R"))
source(here("src", "data_loader.R"))

#' generate data frame by mptype and prepocessing for tooltip
#'
#' @param mptype ("Confirmed", "Death" or "Recovered")
#'
#' @return data frame
mp_data_selection <- function(mptype = "Confirmed"){
  if (mptype == "Confirmed")
    data <-  get_timeseries_data_by_casetype(1)
  else if (mptype == "Death")
    data <-  get_timeseries_data_by_casetype(2)
  else if (mptype == "Recovered")
    data <-  get_timeseries_data_by_casetype(3)
  else
    print("Incorrect type")
  
  data_latest <- data %>% 
    filter(variable == max(variable)) %>% 
    mutate( Country = factor(`Country/Region`, unique(`Country/Region`))) %>%
    mutate( mptext=paste(
      "Country: ", Country, "\n", 
      "Cases: ", value, sep="")
    )
  
  data_latest
}



#' generate world map bubble chart
#'
#' @param dataframe
#'
#' @return a plotly chart object
mp_create_world_map_chart <- function(data_latest){
  world <- map_data("world")
  mp_breaks <- c(1, 50, 3000, 150000, 8000000)
  
  mp_map <- data_latest %>%
    ggplot() +
    geom_polygon(data = world, 
                 aes(x=long, y = lat, group = group), 
                 fill="grey", 
                 alpha=0.3) +
    geom_point(aes(x=Long, y=Lat, size=value, color=value, text = mptext, alpha = 0.4)) +
    scale_size_continuous(name="Cases", 
                          trans="log", 
                          range=c(1,10),
                          breaks=mp_breaks,
                          labels = c("1", "50", "3000", "150,000", "8,000,000+")) +
    scale_color_viridis_c(option="inferno",
                          name="Cases", 
                          trans="log",
                          breaks=mp_breaks,
                          labels = c("1", "50", "3000", "150,000", "8,000,000+"))  +
    theme_void() 
  
  ggplotly(mp_map, tooltip="text")
}
mp_create_world_map_chart(mp_data_selection("Confirmed"))

#' define drop box list
drop_list <- list(list(label="Confirmed", value= "Confirmed"),
                  list(label="Recovered", value= "Recovered"),
                  list(label="Death", value= "Death")
)


#' create mid panel component
#'
#' @return a htmlDiv component
#' @export
#'
#' @examples
#' create_right_panel
create_mid_panel <- function(){
  data_path = paste0(here(), "/data/raw")
  mptype = "Confirmed"
  df <- mp_data_selection(mptype)
  world_chart <- mp_create_world_map_chart(df)
  
  middle_panel <- htmlDiv(
    list(
      dbcRow(dbcCol(htmlH1("World Map"))),
      dbcRow(dbcCol(htmlDiv(
        list(
          dbcRow(dbcCol(dccDropdown(id="mp_dropdown",
                                    options=drop_list, value = "Confirmed"))),
          dbcRow(dbcCol(dccGraph(id="world_chart_bubble", figure = world_chart)))
        )
      )))
    )
  )
  
  middle_panel
}

# refresh the panel upon callbacks
mp_refresh <- function(mptype){
  df <- mp_data_selection(mptype)
  world_chart <- mp_create_world_map_chart(df) 
  
  world_chart
}





