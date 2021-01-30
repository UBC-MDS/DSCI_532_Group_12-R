# Reflection

## Progress of the dashboard:

Following our dashboard in milestone 2 and proposal, we have implemented the COVID-19 dashboard with three separate panels. In the dashboard of milestone 1, three panels are combined horizontally. In milestone 2, however, two panels are combined horizontally and the other panel combined vertically. The details of three panels are below.

- The top left panel contains a bar chart that shows the ranking of the case count. There are 4 cases which are Confirmed Cases, Active Cases, Recovered Cases, or Deaths and the user could choose a specific case by using dropbox.

- The top right panel contains the distribution of the cases geographically in a map, and the user could choose cases among Confirmed Cases, Death Cases, or Recovered cases by using dropbox.

- In the low panel, the user can check the detailed trend by country and category. Meanwhile, the low panel also shows the user how many cases in the selected category each country currently has.

 

## Brief discussion and improvement:

From the experience of implementing the dashboard, we have found that there is no huge difference between implementation by using python and by using R. Both languages allow us to create easily various charts that we can display on the dashboard. However, we used python for downloading raw data which is updated every day, and pre-processing raw data. For convenience, a python script for data processing is used in milestone 2 as well.   

For deploying on Heroku, using python was more convenient than using R. During deploying on Heroku by using R, we have encountered few unexpected errors. Furthermore, it takes more time to load than using python.

As the TA mentioned in <a href=https://github.com/UBC-MDS/DSCI_532_Group_12/issues/44>feedback</a>, the trickiest part is managing the spacing and alignment of charts in separate three panels. Since the dashboard has three separate panels and four charts with different size, allocating suitable size for each panel and each chart needs lots of effort. Furthermore, the world map in the dashboard of milestone 1 is not resized automatically when we change the size of the browser.

 

Based on feedbacks and our discussion about improvement, we have concluded that we need more improvements for a better user experience. The details about possible improvements are below.

- Add brief instruction which includes introduction about app, data source, data update frequency, and data last updated timestamp to improve user experience.

- Change the spacing and alignment of charts for the better user experience

- Add some interaction between bar charts about the ranking of ranking to the world map bubble chart, which allows the user to highlight the specific countries distribution in the map when clicking on the bar chart.

- Add cumulative statistics at a global scale on the left panel

- Allow viewing a country's statistics upon being selected from the map

- Improve loading speed for Heroku which is deploying by using R

- Improve the user experience of the dashboard, and use more meaningful color to represent the data in the visualization.

