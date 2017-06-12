library(shiny)

    fluidPage(
      
      # Add a title
      titlePanel("Mean & Median"),
      numericInput("max", "Input Maximum number", 2),
      numericInput("min", "Input Minimum number", -2), 
      sliderInput(inputId = "opt.cex", label = "Point Size (cex)",                            
                  min = 0, max = 5, step = 0.25, value = 2),
      
      
      # Add a row for the main content
      fluidRow(
        
        # Create a space for the plot output
        plotOutput(
          "clusterPlot", "100%", "500px", click="clusterClick"
        )
      ),
      
      # Create a row for additional information
      fluidRow(
        
        mainPanel("Points: ", verbatimTextOutput("numPoints")),
        sidebarPanel(actionButton("clear", "Clear Points")),
        
        # Take up 2/3 of the width with this element  
        sidebarPanel(actionButton("mean", "Mean")),
        sidebarPanel(actionButton("median", "Median"))
        
        # And the remaining 1/3 with this one
      )    
    )
    
