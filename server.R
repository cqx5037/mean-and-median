library(shinydashboard)
library(reshape2)
library(shiny)
library(Cairo) 

server <- function(input, output) {
  
  # Create a spot where we can store additional
  # reactive values for this session
  val <- reactiveValues(x=NULL, y=NULL)    
  
  # Listen for clicks
  observe({
    # Initially will be empty
    if (is.null(input$clusterClick)){
      return()
    }
    
    isolate({
      val$x <- c(val$x, input$clusterClick$x)
      val$y <- c(val$y, input$clusterClick$y)
    })
  })
  
  # Count the number of points
  output$numPoints <- renderText({
    length(val$x)
  })
  # Clear the points on button click
  observe({
    if (input$clear > 0){
      val$x <- NULL
      val$y <- NULL
      input$mean == 0
      input$median == 0
      input$clear == 0 
    }
  })
  
  # Generate the plot of the clustered points
  output$clusterPlot <- renderPlot({
    
    tryCatch({
      # Format the data as a matrix
      data1 <- data.frame(c(val$x, 0))
      
      # Try to cluster       
      if (length(val$x) <= 1){
        stop("We can't cluster less than 2 points")
      } 
      suppressWarnings({
        fit <- Mclust(data)
      })
      
      mclust2Dplot(data = data1, what = "classification", 
                   classification = fit$classification, main = FALSE,
                   xlim=c(-2,2), ylim=c(0,5),cex=input$opt.cex, cex.lab=input$opt.cexaxis)
    }, error=function(warn){
      # Otherwise just plot the points and instructions
      plot(data1, xlim=c(input$min, input$max), ylim=c(0, 5), xlab="X", ylab="Y",
           cex=input$opt.cex, cex.lab=input$opt.cexaxis,pch=16)
      
      
      if (input$mean > 0 & length(val$x) > 2){
     points.default (mean(val$x),0,col="blue",cex=input$opt.cex, cex.lab=input$opt.cexaxis,pch=16)
      }
      if (input$median  > 0 & length(val$x) > 2 ){
      points.default (median(val$x),0,col="red",cex=input$opt.cex, cex.lab=input$opt.cexaxis,pch=16)
      }
      
    })
  })
}
