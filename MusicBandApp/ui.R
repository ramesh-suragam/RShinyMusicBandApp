#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fieldsMandatory <- c("name", "band")

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
  titlePanel("Musician Page"),
  
  div(
    id = "form",
    textInput("name", labelMandatory("Musician Name"), ""),
    textInput("band", labelMandatory("Band Name")),
    selectInput("role_in_band", labelMandatory("Role in the Band"),
                c("",  "Vocalist", "Guitarist", "Bassist", "Drummer")),
    actionButton("submit", "Submit", class = "btn-primary")
  )
  
)