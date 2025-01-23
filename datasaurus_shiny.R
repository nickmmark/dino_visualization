# Load required libraries
library(shiny)
library(ggplot2)
library(datasauRus)
library(dplyr)
library(gganimate)
library(gifski)

# Define UI
ui <- fluidPage(
  titlePanel("Datasaurus Dozen Shiny App"),
  sidebarLayout(
    sidebarPanel(
      h3("Summary Statistics"),
      textOutput("xMean"),
      textOutput("yMean"),
      textOutput("xSD"),
      textOutput("ySD"),
      textOutput("correlation"),
      br(),
      h3("Options"),
      checkboxInput("showCorrelation", "Show Correlation Line", value = FALSE),
      checkboxInput("showAnimation", "Show Animated Comparison", value = FALSE),
      br(),
      h3("Navigation"),
      fluidRow(
        column(6, actionButton("prevDataset", "← Previous")),
        column(6, actionButton("nextDataset", "Next →"))
      ),
      br(),
      h3("Select a Dataset"),
      selectInput(
        "datasetSelector",
        label = NULL, # No label for a cleaner look
        choices = unique(datasaurus_dozen$dataset), # Dropdown options
        selected = "away"
      )
    ),
    mainPanel(
      plotOutput("selectedPlot", height = "500px"), # Plot for the selected dataset
      conditionalPanel(
        condition = "input.showAnimation == true",
        imageOutput("animatedPlot", height = "500px") # Animated plot as an image
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Get the list of datasets
  datasets <- unique(datasaurus_dozen$dataset)
  
  # Reactive value to track the current dataset index
  currentIndex <- reactiveVal(which(datasets == "away"))
  
  # Update the dataset selector when left or right buttons are clicked
  observeEvent(input$prevDataset, {
    currentIndex(max(1, currentIndex() - 1)) # Prevent going below the first dataset
    updateSelectInput(session, "datasetSelector", selected = datasets[currentIndex()])
  })
  
  observeEvent(input$nextDataset, {
    currentIndex(min(length(datasets), currentIndex() + 1)) # Prevent going beyond the last dataset
    updateSelectInput(session, "datasetSelector", selected = datasets[currentIndex()])
  })
  
  # Update the index when the dropdown selection changes
  observeEvent(input$datasetSelector, {
    currentIndex(which(datasets == input$datasetSelector))
  })
  
  # Reactive expression to get the selected dataset
  selected_data <- reactive({
    datasaurus_dozen %>% filter(dataset == input$datasetSelector)
  })
  
  # Render the plot for the selected dataset
  output$selectedPlot <- renderPlot({
    p <- ggplot(selected_data(), aes(x = x, y = y)) +
      geom_point() +
      xlim(0, 100) + ylim(0, 100) + # Lock axes
      theme_minimal() +
      ggtitle(paste("Dataset:", input$datasetSelector))
    if (input$showCorrelation) {
      p <- p + geom_smooth(method = "lm", color = "blue", se = FALSE)
    }
    p
  })
  
  # Render the animated plot showing transitions between datasets
  output$animatedPlot <- renderImage({
    req(input$showAnimation) # Ensure animation only renders when checkbox is checked
    
    # Compute summary statistics for each dataset
    stats <- datasaurus_dozen %>%
      group_by(dataset) %>%
      summarise(
        x_mean = round(mean(x), 2),
        y_mean = round(mean(y), 2),
        x_sd = round(sd(x), 2),
        y_sd = round(sd(y), 2),
        correlation = round(cor(x, y), 2)
      )
    
    # Create the animated plot
    anim <- ggplot(datasaurus_dozen, aes(x = x, y = y, group = dataset)) +
      geom_point() +
      xlim(0, 100) + ylim(0, 100) + # Lock axes
      geom_text(
        data = stats,
        aes(
          x = 100, y = 0, # Position of the stats on the plot
          label = paste(
            "X Mean:", x_mean,
            "\nY Mean:", y_mean,
            "\nX SD:", x_sd,
            "\nY SD:", y_sd,
            "\nCorrelation:", correlation
          )
        ),
        hjust = 1,
        vjust = 0,
        inherit.aes = FALSE
      ) +
      theme_minimal() +
      labs(title = "Beware summary statistics: lesson from the dinosauRus dataset", subtitle = "{closest_state}") +
      transition_states(dataset, transition_length = 2, state_length = 1) +
      enter_fade() +
      exit_fade()
    
    # Save the animation as a GIF
    gif_file <- tempfile(fileext = ".gif")
    animate(anim, renderer = gifski_renderer(gif_file))
    
    # Return the GIF file to be displayed
    list(src = gif_file, contentType = "image/gif", alt = "Animated Plot")
  }, deleteFile = TRUE)
  
  # Render each statistic as separate text outputs
  output$xMean <- renderText({
    paste("X Mean:", round(mean(selected_data()$x), 2))
  })
  output$yMean <- renderText({
    paste("Y Mean:", round(mean(selected_data()$y), 2))
  })
  output$xSD <- renderText({
    paste("X SD:", round(sd(selected_data()$x), 2))
  })
  output$ySD <- renderText({
    paste("Y SD:", round(sd(selected_data()$y), 2))
  })
  output$correlation <- renderText({
    paste("Correlation (X, Y):", round(cor(selected_data()$x, selected_data()$y), 2))
  })
}

# Run the app
shinyApp(ui = ui, server = server)



