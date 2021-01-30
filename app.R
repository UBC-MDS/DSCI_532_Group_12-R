library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(here)


source(here("src", "left_panel.R"))
source(here("src", "right_panel.R"))
source(here("src", "mid_panel.R"))
source(here("src", "stylesheet.R"))



data_path = paste0(here(), "/data/raw")

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
app$title("Covid-19 Data Portal")

# components
right_panel <- create_right_panel()

mid_panel <- create_mid_panel()

left_panel <- htmlDiv(htmlH1("Global"))
 
pageTitle <- htmlH1('Covid-19 Data Portal',
                    style = heading)

# Main app layout
app$layout(dbcContainer(list(dbcRow(dbcCol(
  pageTitle
)),
dbcRow(
  list(dbcCol(left_panel),
       dbcCol(mid_panel),
       dbcCol(right_panel))
  
))
  ,style = list('max-width' = '85%')))

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
  # # ctx <- app$callback_context()
  # ntype="Total"
  # # if (!is.null(ctx) && ctx$triggered$value){
  # #   btn_id <- unlist(strsplit(ctx$triggered$prop_id, "[.]"))[1]
  # #   if (btn_id == "rp_btn_new")
  # #     ntype="New"
  # # }
  rp_refresh(country, count_type)
})



# Callback Handling for Left Panel
app$callback(list(
  output("chart_cases_ranking", "figure")
),
list(
   input("c_type", "value")
),
function(c_type) {
  lp_refresh(c_type)
})


# Callback Handling for Mid Panel
app$callback(
  output("world_chart_bubble", "figure"),
  list(input("mp_dropdown", "value")),
  function(mptype) {
    df <- mp_data_selection(mptype)
    world_chart <- mp_create_world_map_chart(df)
    }
)

app$run_server(host = '127.0.0.1', port = Sys.getenv('PORT', 8050)) 
