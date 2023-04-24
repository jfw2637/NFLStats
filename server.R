library(shiny)
library(waiter)
source("router.R")
source("NFL Data.R")

waiting_screen <- tagList(
  spin_flower(),
  h4("Initializing...")
) 


server <- function(input, output, session) {
  router_server()
  
  #waiter_show(html = waiting_screen)
  #pbp_data<-get_pbp_data()
  #waiter_hide()
  
  v <- reactiveValues(plot = NULL)

  observeEvent(input$runOptimization,{
    waiter_show(
      spin_loaders(10),
      id = "plot1",
      color = "grey"
    )
    v$plot<-plot_yard_histogram(pbp_data)
    waiter_hide("plot1")
  })

  output$plot1 <- renderPlot({
    v$plot
  })
  
  
}