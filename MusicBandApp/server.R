#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("ui.R")
library(shiny)

fieldsAll <- c("musician_name", "musician_band", "musician_role")
responsesDir <- file.path("data")
epochTime <- function() {
  as.integer(Sys.time())
}

formData <- reactive({
  data <- sapply(fieldsAll, function(x) input[[x]])
  data <- c(data, timestamp = epochTime())
  data <- t(data)
  data
})

humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")

saveData <- function(data) {
  fileName <- sprintf("%s_%s.csv",
                      humanTime(),
                      digest::digest(data))

  write.csv(x = data, file = file.path(resposnesDir, fileName),
            row.names = FALSE, quote = TRUE)
  }

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  observe({
    mandatoryFilled <-
      vapply(fieldsMandatory,
             function(x){
               !is.null(input[[x]]) && input[[x]] != ""
             },
             logical(1))
    mandatoryFilled <- all(mandatoryFilled)
    
    shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
  })
  observeEvent(input$submit, {
    saveData(formData())
  })
})
