#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# fieldsMandatory <- c("b_name")
fieldsBand <- c("b_name", "b_active_from", "b_active_to")
fieldsMusician <- c("m_name", "m_band", "m_instruments", "m_vocals", "m_active_from", "m_active_to")
fieldsAlbum <- c("a_name", "a_year", "a_musician")
# 
# labelMandatory <- function(label) {
#   tagList(
#     label,
#     span("*", class = "mandatory_star")
#   )
# }
# 
# appCSS <- ".mandatory_star { color:red; }"
# 
# ui2 <- fluidPage(
#   shinyjs::useShinyjs(),
#   shinyjs::inlineCSS(appCSS),
#   titlePanel("Band Page"),
#   
#   div(
#     id = "form",
#     textInput("b_name", labelMandatory("Band Name"), ""),
#     selectInput("b_active_from", "Active From:", choices = 2014:2100),
#     selectInput("b_active_to", "Active To:", choices = 2014:2100),
#     actionButton("submit", "Submit", class = "btn-primary")
#   )
#   
# )

# globla variables
not_sel = ""

add_band_page <- tabPanel(
  title = "Bands",
  titlePanel("Add Band"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form",
      textInput("b_name", labelMandatory("Band Name"), ""),
      selectInput("b_active_from", "Active From:", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("b_active_to", "Active To:", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      actionButton("create_band", "Create Band", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Plot"
        ),
        tabPanel(
          title = "Statistics",
        )
      )
    )
  )
)

add_musician_page <- tabPanel(
  title = "Musicians",
  titlePanel("Add Musicians"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form",
      textInput("m_name", labelMandatory("Musician Name"), ""),
      # selectInput("m_band", "Band Name:", choices = NULL, selected = NULL, multiple = FALSE),
      uiOutput('ui_m_band'),
      selectInput("m_instruments", "Instrument:", choices = c(not_sel, "Bass", "Drums", "Guitars", "Keyboards", "Piano")),
      selectInput("m_vocals", "Vocals:", choices = c(not_sel, "Lead Vocals", "Backing vocals")),
      selectInput("m_active_from", "Active From:", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("m_active_to", "Active To:", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      actionButton("create_musician", "Create Musician", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Plot"
        ),
        tabPanel(
          title = "Statistics",
        )
      )
    )
  )
)

add_album_page <- tabPanel(
  title = "Albums",
  titlePanel("Add Albums"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form",
      textInput("a_name", labelMandatory("Album Name"), ""),
      selectInput("a_year", "Release Year:", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("a_musician", "Album Musician:", choices = c(not_sel)),
      actionButton("create_album", "Create Album", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Plot"
        ),
        tabPanel(
          title = "Statistics",
        )
      )
    )
  )
)

about_page <- tabPanel(
  title = "About",
  titlePanel("About"),
  "Created with R Shiny",
  br(),
  "2021 April"
)

ui <- navbarPage(
  title = "Music Bands Website",
  # main_page,
  add_band_page,
  add_musician_page,
  add_album_page,
  about_page
)
