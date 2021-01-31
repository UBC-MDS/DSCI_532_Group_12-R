---
editor_options: 
  markdown: 
    wrap: 72
---

# Reflection

## Progress of the dashboard:

Following our dashboard in milestone 2 and proposal, we have implemented
the COVID-19 dashboard with three separate panels and those panels are
combined horizontally. The details of three panels are below.

-   The top left panel contains a bar chart that shows the ranking of
    the case count. There are 4 cases which are Confirmed Cases, Active
    Cases, Recovered Cases, or Deaths and the user could choose a
    specific case by using dropbox.

-   The top right panel contains the distribution of the cases
    geographically in a map, and the user could choose cases among
    Confirmed Cases, Death Cases, or Recovered cases by using dropbox.

-   In the low panel, the user can check the detailed trend by country
    and category. Meanwhile, the low panel also shows the user how many
    cases in the selected category each country currently has.

## Brief discussion and improvement:

From the experience of implementing the dashboard, we have found that
there is no huge difference between implementation by using python and
by using R. Both languages allow us to create easily various charts that
we can display on the dashboard. However, we used python for downloading
raw data which is updated every day, and pre-processing raw data. For
convenience, a python script for data processing is used in milestone 2
as well.

Deploying a Python project on Heroku was simpler than deploying an R
project. During deploying the R project on Heroku, we have encountered
few unexpected errors, especially when using `reticulate` library to
re-use some Python code. Furthermore, it takes more time to load the
dashboard than using python, some performance profiling should be done
to figure out if it is caused by implementation or not.

As the TA mentioned in
[feedback](https://github.com/UBC-MDS/DSCI_532_Group_12/issues/44), the
trickiest part is managing the spacing and alignment of charts in
separate three panels. Since the dashboard has three separate panels and
four charts with different size, allocating suitable size for each panel
and each chart needs lots of effort. Furthermore, the world map in the
dashboard of milestone 1 is not re-sized automatically when we change
the size of the browser.

Based on the feedback and our discussion about improvements, we have
concluded that we need more improvements for a better user experience.
The details about possible improvements are below.

**High priority improvements**:

-   Improve loading speed of the dashboard implemented in R on Heroku

-   Improve the legend of world map by reverse the direction of the
    legend color order

-   Fix inconsistencies in wording (example: Confirmed Cases, Confirmed)
    across the three panels

-   Add tooltip to show number of cases for each country and adding some
    padding between each bar on the left panel

**Lower priority improvements**:

-   Add brief instruction which includes introduction about app, data
    source, data update frequency, and data last updated timestamp

-   Change the spacing and alignment of charts

-   Add some interaction between bar charts about the ranking of ranking
    to the world map bubble chart, which allows the user to highlight
    the specific countries distribution in the map when clicking on the
    bar chart

-   Add cumulative statistics at a global scale on the left panel

-   Allow viewing a country's statistics upon being selected from the
    map

-   Apply SI format for numbers shown in tooltips
