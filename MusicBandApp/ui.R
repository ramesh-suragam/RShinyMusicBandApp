#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyalert)

fieldsBandMandatory <- c("b_name")
fieldsMusicianMandatory <- c("m_name", "m_band", "m_instruments")
fieldsAlbumMandatory <- c("a_name", "a_year", "a_musician")

fieldsBand <- c("b_name", "b_active_from", "b_active_to")
fieldsViewBand <- c("v_band")
fieldsMusician <- c("m_name", "m_band", "m_instruments", "m_vocals", "m_active_from", "m_active_to")
fieldsViewMusician <- c("v_musician")
fieldsAlbum <- c("a_name", "a_year", "a_musician", "a_recording_type")

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}
 
appCSS <- ".mandatory_star { color:red; }"
# 
# ui2 <- fluidPage(
#   shinyjs::useShinyjs(),
#   shinyjs::inlineCSS(appCSS),
#   titlePanel("Band Page"),
#   
#   div(
#     id = "form",
#     textInput("b_name", labelMandatory("Band Name"), ""),
#     selectInput("b_active_from", "Active From", choices = 2014:2100),
#     selectInput("b_active_to", "Active To", choices = 2014:2100),
#     actionButton("submit", "Submit", class = "btn-primary")
#   )
#   
# )

# globlal variables
not_sel = ""

add_band_page <- tabPanel(
  shinyjs::useShinyjs(),
  useShinyalert(),
  title = "Add Bands",
  titlePanel("Add Band"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form1",
      textInput("b_name", labelMandatory("Band Name"), ""),
      selectInput("b_active_from", "Active From", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("b_active_to", "Active To", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      actionButton("create_band", "Create Band", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      # tabsetPanel(
      #   tabPanel(
      #     title = "Plot"
      #   ),
      #   tabPanel(
      #     title = "Statistics",
      #   )
      # )
    )
  )
)

view_band_page <- tabPanel(
  title = "View Bands",
  titlePanel("View Band"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form2",
      uiOutput('ui_v_b_name'),
      actionButton("view_band", "View Band Summary", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Plot",
          highcharter::highchartOutput("plot1")
        # ),
        # tabPanel(
        #   title = "Statistics",
        )
      )
    )
  )
)

add_musician_page <- tabPanel(
  shinyjs::useShinyjs(),
  title = "Add Musicians",
  titlePanel("Add Musicians"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form3",
      textInput("m_name", labelMandatory("Musician Name"), ""),
      uiOutput('ui_m_band'),
      selectInput("m_instruments", "Instrument", choices = c(not_sel, "Bass", "Drums", "Guitars", "Keyboards", "Piano")),
      selectInput("m_vocals", "Vocals", choices = c(not_sel, "Lead Vocals", "Backing vocals")),
      selectInput("m_active_from", "Active From", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("m_active_to", "Active To", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      actionButton("create_musician", "Create Musician", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      # tabsetPanel(
      #   tabPanel(
      #     title = "Plot"
      #   ),
      #   tabPanel(
      #     title = "Statistics",
      #   )
      # )
    )
  )
)

view_musician_page <- tabPanel(
  title = "View Musicians",
  titlePanel("View Musician"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form4",
      uiOutput('ui_v_m_name'),
      actionButton("view_musician", "View Musician History", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Plot",
          tableOutput("table1")
        # ),
        # tabPanel(
        #   title = "Statistics",
        )
      )
    )
  )
)

add_album_page <- tabPanel(
  shinyjs::useShinyjs(),
  title = "Add Albums ",
  titlePanel("Add Albums"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form5",
      textInput("a_name", labelMandatory("Album Name"), ""),
      selectInput("a_year", "Release Year", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("a_recording_type", "Recording Type", choices = c(not_sel, "Live", "Studio")),
      uiOutput('ui_a_musician'),
      actionButton("create_album", "Create Album", class = "btn-primary", icon=icon("plus-square"))
    ),
    mainPanel(
      # tabsetPanel(
      #   tabPanel(
      #     title = "Plot"
      #   ),
      #   tabPanel(
      #     title = "Statistics",
      #   )
      # )
    )
  )
)

view_album_page <- tabPanel(
  title = "View Albums ",
  titlePanel("View Album"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      id = "form",
      textInput("a_name", labelMandatory("Album Name"), ""),
      selectInput("a_year", "Release Year", choices = c(not_sel, format(Sys.Date(), "%Y"):1930)),
      selectInput("a_recording_type", "Recording Type", choices = c(not_sel, "Live", "Studio")),
      uiOutput('ui_a_musician'),
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
  navbarMenu(
    title = "Bands",
    add_band_page,
    view_band_page
  ),
  navbarMenu(
    title = "Musicians",
    add_musician_page,
    view_musician_page
  ),
  add_album_page,
  about_page
)
