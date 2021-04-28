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

# Creating a global connection object to database
con <- dbConnect(SQLite(), sqlitePath)

# function to get the system date 
epochTime <- function() {
  as.integer(Sys.time())
}

humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")

# DB code to create a new band
createBandData <- function(data) {

    # Construct the update query by looping over the data fields
  insert_band_query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    tbl_band, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  
  rs <- dbSendQuery(con, insert_band_query)
  # print(dbFetch(rs))
  dbClearResult(rs)
}



# loadData <- function() {
#   # Connect to the database
#   db <- dbConnect(SQLite(), sqlitePath)
#   # Construct the fetching query
#   query <- sprintf("SELECT * FROM %s", tbl_band)
#   # Submit the fetch query and disconnect
#   data <- dbGetQuery(db, query)
#   dbDisconnect(db)
#   data
# }

# DB code to create a new band
createMusicianData <- function(data) {
  
  # Construct the update query by looping over the data fields
  insert_musician_query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    tbl_band_musician, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  
  rs <- dbSendQuery(con, insert_musician_query)
  # print(dbFetch(rs))
  dbClearResult(rs)
}


sqlOutputBandClass <- reactive({

  sqlInputBandClass<- sprintf(
    "SELECT distinct b_name FROM tbl_band"
    # tbl_band
  )
  
  print(sqlInputBandClass)

  dbGetQuery(con, sqlInputBandClass)
})

# observe ({
#   updateSelectInput(session,"pick_assetclass","ASSET CLASS",
#                     choices = sqlOutputAssetClass()
#   )
# })

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
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
  
  # observe({
  #   updateSelectInput(session,"m_band","Band Name:",
  #                     choices = sqlOutputBandClass())
  # })
  
  output$ui_m_band <- renderUI({
    selectInput('m_band',
                label ='Band Name',
                choices=sqlOutputBandClass(),
                selected = NULL, multiple = FALSE)
  })
  
  bandFormData <- reactive({
    data <- sapply(fieldsBand, function(x) input[[x]])
    data <- c(data, b_timestamp = humanTime())
    data
  })
  
  musicianFormData <- reactive({
    data <- sapply(fieldsMusician, function(x) input[[x]])
    data <- c(data, m_timestamp = humanTime())
    data
  })
  
  observeEvent(input$create_band, {
    createBandData(bandFormData())
    # loadData()
  })
  
  observeEvent(input$create_musician, {
    createMusicianData(musicianFormData())
  })
})

onStop(function() {
  dbDisconnect(con)
})

