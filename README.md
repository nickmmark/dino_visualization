# dino_visualization
Summary stats can be deceiving! Here's an Rstats visualization of the dinosauRus dataset to make the point

![](https://github.com/nickmmark/dino_visualization/blob/main/dinosaurus_animated.gif)

### Overview
This app is a demonstration of the importance of visualizing data. Using the [dinosauRus](https://cran.r-project.org/web/packages/datasauRus/vignettes/Datasaurus.html) package it highlights how datasets with similar summary statistics can have radically different patterns, emphasizing that data visualization is an essential step in data analysis.

### Features
* Users can select a dataset from a dropdown menu or navigate sequentially using "Previous" and "Next" buttons.
Summary Statistics:
* The app calculates and displays key summary statistics for each dataset: (X Mean, Y Mean, X Standard Deviation, Y Standard Deviation, Correlation between X and Y)

The Shiny framework dynamically updates the visualizations and statistics in response to user inputs. You can play with the resulting Shiny App [here](https://nickmmark.shinyapps.io/data_science/)

To help visualize and explore the `dinosauRus` data, the app leverages:
`ggplot2` for plotting.
`gganimate` for creating smooth transitions between datasets in the animation.
`gifski` to render animations as GIFs for display in the app.

Explore and have fun!

### License
None! Use this freely to teach about the importance of data visualization!
