# dino_visualization
Summary stats can be deceiving! Rstats visualization of the dinosauRus dataset



### Overview
This app is a demonstration of the importance of visualizing data. It highlights how datasets with similar summary statistics can have radically different patterns, emphasizing that data visualization is an essential step in data analysis.

### Features
* Users can select a dataset from a dropdown menu or navigate sequentially using "Previous" and "Next" buttons.
Summary Statistics:
* The app calculates and displays key summary statistics for each dataset: (X Mean, Y Mean, X Standard Deviation, Y Standard Deviation, Correlation between X and Y)

The Shiny framework dynamically updates the visualizations and statistics in response to user inputs.
The app leverages:
`ggplot2` for plotting.
`gganimate` for creating smooth transitions between datasets in the animation.
`gifski` to render animations as GIFs for display in the app.


