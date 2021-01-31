library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(here)

source(here("src", "data_loader.R"))
source(here("src", "left_panel.R"))
source(here("src", "right_panel.R"))
source(here("src", "mid_panel.R"))
source(here("src", "stylesheet.R"))



data_path = paste0(here(), "/data/raw")

app <- Dash$new(external_stylesheets = dbcThemes$COSMO)
app$title("Covid-19 Data Portal")

# components
right_panel <- create_right_panel()

mid_panel <- create_mid_panel()

left_panel <- create_left_panel()
 
pageTitle <- htmlH1('Covid-19 Data Portal',
                    style = heading)

# Main app layout
app$layout(dbcContainer(list(dbcRow(dbcCol(
  pageTitle
)),
dbcRow(
  list(dbcCol(left_panel, width=3),
       dbcCol(mid_panel, width=6),
       dbcCol(right_panel, width=3))
  
))
  ,style = list('max-width' = '95%')))

# Callback Handling for Right Panel
app$callback(list(
  output("lb_confirmed", "children"),
  output("lb_recovered", "children"),
  output("lb_deaths", "children"),
  output("chart_confirmed_trend", "figure"),
  output("chart_deaths_trend", "figure")
),
list(
  input("dd_country", "value"),
  input("rp_radio_count_type", "value")
),
function(country, count_type) {
  c_chart <- rp_refresh(country, count_type)
})


# Callback Handling for Left Panel
app$callback(
  output("chart_cases_ranking", "figure"),
  list(input("lp_c_type", "value")),
  function(c_type) {
    global_total_numbers <- get_global_total_numbers()
    c_chart <- lp_create_chart(global_total_numbers, c_type)
  }
)


# Callback Handling for Mid Panel
app$callback(
  output("world_chart_bubble", "figure"),
  list(input("mp_dropdown", "value")),
  function(mptype) {
    df <- mp_data_selection(mptype)
    world_chart <- mp_create_world_map_chart(df)
    }
)

app$run_server(host = '127.0.0.1', debug = T)

# app$run_server(host = '0.0.0.0') 
