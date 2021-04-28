#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Loading the required libraries
source("ui.R")
library(shiny)
library(RSQLite)

# declaring the database and table variables
sqlitePath <- "data/MusicDB.db"
tbl_band <- "tbl_band"
tbl_musician <- "tbl_musician"
tbl_band_musician <- "tbl_band_musician"
tbl_album <- "tbl_album"

# function to get the system date 
epochTime <- function() {
  as.integer(Sys.time())
}

humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")

saveData <- function(data) {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)

    # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    tbl_band, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  
  print(query)
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

loadData <- function() {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", tbl_band)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
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
  
  formData <- reactive({
    data <- sapply(fieldsBand, function(x) input[[x]])
    data <- c(data, b_timestamp = humanTime())
    print(data)
    # data <- t(data)
    print(data)
    data
  })
  
  observeEvent(input$submit, {
    saveData(formData())
    # loadData()
  })
})
