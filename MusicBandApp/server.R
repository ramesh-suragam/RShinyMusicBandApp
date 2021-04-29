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
# library(AnnotationDbi)

# declaring the database and table variables
sqlitePath <- "data/MusicDB.db"
tbl_band <- "tbl_band"
tbl_band_musician <- "tbl_band_musician"
tbl_album <- "tbl_album"

# Creating a global connection object to database
con <- dbConnect(SQLite(), sqlitePath)

# queries
sqlInputBandClass<- sprintf("SELECT distinct b_name FROM tbl_band ORDER BY b_name ASC")
sqlInputMusicianClass <- sprintf("SELECT distinct m_name FROM tbl_band_musician ORDER BY m_name ASC")

# function to get the system date 
epochTime <- function() {
  as.integer(Sys.time())
}

# function to get the system date in human readable format
humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")

# Code to get list of bands from database
sqlOutputBandClass <- reactive({
  unname(dbGetQuery(con, sqlInputBandClass))
})

# Code to get list of musicians from database
sqlOutputMusicianClass <- reactive({
  dbGetQuery(con, sqlInputMusicianClass)
})

# DB code to create a new band, musician, album
createTableData <- function(table, data) {
  insert_query <- sprintf('INSERT INTO %s (%s) VALUES (\"%s\")', table, paste(names(data), collapse = ", "), paste(data, collapse = "\", \""))
  print(insert_query)
  rs <- dbSendQuery(con, insert_query)
  dbClearResult(rs)
}

# DB code to get related band data
getBandMemberData <- function(table, data) {
  print(data)
  select_query <- sprintf('SELECT * FROM %s WHERE m_band = \"%s\"', table, data)
  print(select_query)
  data <- dbGetQuery(con, select_query)
  data
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Retrieve band form data
  bandFormData <- reactive({
    data <- sapply(fieldsBand, function(x) input[[x]])
    data <- c(data, b_timestamp = humanTime())
    data
  })
  
  # Retrieve view band form data
  viewBandFormData <- reactive({
    data <- sapply(fieldsViewBand, function(x) input[[x]])
    data
  })
  
  # Retrieve musician form data
  musicianFormData <- reactive({
    data <- sapply(fieldsMusician, function(x) input[[x]])
    data <- c(data, m_timestamp = humanTime())
    data
  })
  
  # Retrieve album form data
  albumFormData <- reactive({
    data <- sapply(fieldsAlbum, function(x) input[[x]])
    data <- c(data, a_timestamp = humanTime())
    data
  })
  
  # render band drop down on initial startup
  output$ui_m_band <- renderUI({
    selectInput('m_band', label = 'Band Name', choices = c(not_sel, unique(as.character(unlist(sqlOutputBandClass())))), selected = NULL, multiple = FALSE)
  })
  
  # render band drop down on initial startup on view band page
  output$ui_v_b_name <- renderUI({
    selectInput('v_band', label = 'Band Name', choices = c(not_sel, c(not_sel, unique(as.character(unlist(sqlOutputBandClass()))))), selected = NULL, multiple = FALSE)
  })
  
  # render musician drop down on initial startup
  output$ui_a_musician <- renderUI({
    selectInput('a_musician', label = 'Album Musician', choices = c(not_sel, unique(as.character(unlist(sqlOutputMusicianClass())))), selected = NULL, multiple = FALSE)
  })
  
  # Code for dynamic band dropdown
  sqlOutputDynamicBandClass <- eventReactive(input$create_band,({
    unname(dbGetQuery(con, sqlInputBandClass))
  }))
  
  # Code for dynamic musician dropdown
  sqlOutputDynamicMusicianClass <- eventReactive(input$create_musician,({
    unname(dbGetQuery(con, sqlInputMusicianClass))
  }))
  
  # Code to create a new band
  observeEvent(input$create_band, {
    createTableData(tbl_band, bandFormData())
    updateSelectInput(session, "m_band", "Band Name", choices = c(not_sel, unique(as.character(unlist(sqlOutputDynamicBandClass())))), selected = NULL)
    updateSelectInput(session, "v_band", "Band Name", choices = c(not_sel, unique(as.character(unlist(sqlOutputDynamicBandClass())))), selected = NULL)
  })

  # Code to plot band details
  observeEvent(input$view_band, {
    data <- getBandMemberData(tbl_band_musician, viewBandFormData())
    print(data)
  })
  
  # Code to create a new musician
  observeEvent(input$create_musician, {
    createTableData(tbl_band_musician, musicianFormData())
    updateSelectInput(session, "a_musician", "Album Musician", choices = c(not_sel, unique(as.character(unlist(sqlOutputDynamicMusicianClass())))), selected = NULL)
  })
  
  # Code to create a new album
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
#   updateSelectInput(session,"m_band","Band Name",
#                     choices = sqlOutputBandClass())
# })