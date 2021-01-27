library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(here)

source(here("src", "right_panel.R"))
source(here("src", "stylesheet.R"))

data_path = paste0(here(), "/data/raw")

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
app$title("Covid-19 Data Portal")

# components
right_panel <- create_right_panel()

left_panel <- htmlDiv(htmlH1("Global"))
 
mid_panel <- htmlDiv(htmlH1("World Map"))
 
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
  input("rp_btn_total", "n_clicks"),
  input("rp_btn_new", "n_clicks")
),
function(country, total_click, new_click) {
  # ctx <- app$callback_context()
  ntype="Total"
  # if (!is.null(ctx) && ctx$triggered$value){
  #   btn_id <- unlist(strsplit(ctx$triggered$prop_id, "[.]"))[1]
  #   if (btn_id == "rp_btn_new")
  #     ntype="New"
  # }
  rp_refresh(country, ntype)
})


app$run_server(debug = T)