library(shiny)
library(shinyjs)
library(waiter)
source("router.R")

fluidPage(
  useWaiter(),
  shinyjs::useShinyjs(),
  router
)
