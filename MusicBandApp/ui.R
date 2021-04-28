#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fieldsMandatory <- c("b_name")
fieldsBand <- c("b_name", "b_active_from", "b_active_to")

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

appCSS <- ".mandatory_star { color:red; }"


ui <- fluidPage(
  shinyjs::useShinyjs(),
  shinyjs::inlineCSS(appCSS),
  titlePanel("Band Page"),
  
  div(
    id = "form",
    textInput("b_name", labelMandatory("Band Name"), ""),
    selectInput("b_active_from", "Active From:", choices = 2014:2100),
    selectInput("b_active_to", "Active To:", choices = 2014:2100),
    actionButton("submit", "Submit", class = "btn-primary")
  )
  
)