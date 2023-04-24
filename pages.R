library(shiny)
library(shinyWidgets)
source("NFL Data.R")

home_page <- div(
  navbarPage("NFL Stats",
      tabPanel("Plot",
        sidebarLayout(
          sidebarPanel(
            pickerInput(
              inputId = "teamFilter", 
              label = "Teams:", 
              choices = c("Bengals","Buccanneers","Eagles"), 
              options = pickerOptions(
                actionsBox = TRUE, 
                size = 10,
                selectedTextFormat = "count > 3"
              ), 
              multiple = TRUE
            ), 
              pickerInput(
                inputId = "quarterFilter", 
                label = "Quarter:", 
                choices = c("1","2","3","4"), 
                options = pickerOptions(
                  actionsBox = TRUE, 
                  size = 10,
                  selectedTextFormat = "count > 3"
                ), 
              multiple = TRUE
            ),
            pickerInput(
              inputId = "downFilter", 
              label = "Down:", 
              choices = c("1","2","3","4"), 
              options = pickerOptions(
                actionsBox = TRUE, 
                size = 10,
                selectedTextFormat = "count > 3"
              ), 
              multiple = TRUE
            ),
            pickerInput(
              inputId = "homeawayFilter", 
              label = "Home/Away:", 
              choices = c("Home","Away"), 
              options = pickerOptions(
                actionsBox = TRUE, 
                size = 10,
                selectedTextFormat = "count > 3"
              ), 
              multiple = TRUE
            ),
            pickerInput(
              inputId = "seasonFilter", 
              label = "Season Type:", 
              choices = c("Pre Season","Regular Season","Post Season"), 
              options = pickerOptions(
                actionsBox = TRUE, 
                size = 10,
                selectedTextFormat = "count > 3"
              ), 
              multiple = TRUE
            ),
            
            hr(),
            actionButton("runOptimization", "Run Optimization"),
            a(href = route_link("settings"), "Settings"),
            textOutput("errorMessage")
          ),
          mainPanel( 
                       plotOutput(outputId = "plot1")
               
            )
          )
        ),
  tabPanel("Summary",
           plotOutput(outputId = "plot2")  
  ),
  navbarMenu("More",
             tabPanel("Table",
                      plotOutput(outputId = "plot3")
             ),
             tabPanel("About",
                      plotOutput(outputId = "plot4")
             )
    )
  )
)


settings_page <- div(
  titlePanel("Settings"),
  p("This is a settings page")
)

contact_page <- div(
  titlePanel("Contact"),
  p("This is a contact page")
)