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
tbl_band_musician <- "tbl_band_musician"
tbl_album <- "tbl_album"

# queries
sqlInputBandClass<- sprintf("SELECT distinct b_name FROM tbl_band")
sqlInputMusicianClass <- sprintf("SELECT distinct m_name FROM tbl_band_musician")

# Creating a global connection object to database
con <- dbConnect(SQLite(), sqlitePath)

# function to get the system date 
epochTime <- function() {
  as.integer(Sys.time())
}

# function to get the system date in human readable format
humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")

# Code to get list of bands from database
sqlOutputBandClass <- reactive({
  dbGetQuery(con, sqlInputBandClass)
})

# Code to get list of musicians from database
sqlOutputMusicianClass <- reactive({
  dbGetQuery(con, sqlInputMusicianClass)
})

# DB code to create a new band, musician, album
createTableData <- function(table, data) {
  insert_query <- sprintf("INSERT INTO %s (%s) VALUES ('%s')", table, paste(names(data), collapse = ", "), paste(data, collapse = "', '"))
  rs <- dbSendQuery(con, insert_query)
  dbClearResult(rs)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  sqlOutputBandClass2 <- eventReactive(input$create_band,({
    
    dbGetQuery(con, sqlInputBandClass)
  }))
  
  sqlOutputMusicianClass2 <- reactive({
    
    dbGetQuery(con, sqlInputMusicianClass)
  })
  
  output$ui_m_band <- renderUI({
    selectInput('m_band',
                label = 'Band Name',
                choices = sqlOutputBandClass(),
                selected = NULL, multiple = FALSE)
  })
  
  output$ui_a_musician <- renderUI({
    selectInput('a_musician',
                label = 'Album Musician:',
                choices = sqlOutputMusicianClass(),
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
  
  albumFormData <- reactive({
    data <- sapply(fieldsAlbum, function(x) input[[x]])
    data <- c(data, a_timestamp = humanTime())
    data
  })
  
  observeEvent(input$create_band, {
    createTableData(tbl_band, bandFormData())
    updateSelectInput(session,"m_band","Band Name",
                      choices = sqlOutputBandClass2(),
                      selected = NULL)
  })
  
  observeEvent(input$create_musician, {
    createTableData(tbl_band_musician, musicianFormData())
    updateSelectInput(session,"a_musician","Album Musician:",
                      choices = sqlOutputBandClass2(),
                      selected = NULL)
  })
  
  observeEvent(input$create_album, {
    createTableData(tbl_album, albumFormData())
  })
})

onStop(function() {
  dbDisconnect(con)
})

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

# observe ({
#   updateSelectInput(session,"pick_assetclass","ASSET CLASS",
#                     choices = sqlOutputAssetClass()
#   )
# })

# mandotoryFieldsFilled <- function(y){
#   mandatoryFilled <-
#     vapply(y,
#            function(x){
#              !is.null(input[[x]]) && input[[x]] != ""
#            },
#            logical(1))
#   mandatoryFilled <- all(mandatoryFilled)
# }


# observe({
#   mandatoryFilled <-
#     vapply(fieldsMandatory,
#            function(x){
#              !is.null(input[[x]]) && input[[x]] != ""
#            },
#            logical(1))
#   mandatoryFilled <- all(mandatoryFilled)
# 
#   shinyjs::toggleState(id = "create_band", condition = mandatoryFilled)
#   shinyjs::toggleState(id = "create_band", condition = mandotoryFieldsFilled(fieldsBandMandatory))
#   
# })

# observe({
#   updateSelectInput(session,"m_band","Band Name:",
#                     choices = sqlOutputBandClass())
# })