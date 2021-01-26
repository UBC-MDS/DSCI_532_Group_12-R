library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(here)

source(here("src", "right_panel.R"))
source(here("src", "stylesheet.R"))

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
app$title("Covid-19 Data Portal")

# components
right_panel <- create_right_panel()

left_panel <- htmlDiv(htmlH1("Global"))
 
mid_panel <- htmlDiv(htmlH1("World Map"))
 
pageTitle <- htmlH1('Covid-19 Data Portal',
                    style = heading)

# Main app layout
app$layout(dbcContainer(list(
  dbcRow(dbcCol(pageTitle)),
  dbcRow(
    list(
      dbcCol(left_panel),
      dbcCol(mid_panel),
      dbcCol(right_panel)
         )
    
         )
  )
  ,style = list('max-width' = '85%')))

app$run_server(debug = T)