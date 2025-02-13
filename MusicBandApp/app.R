#
# This is the app-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(renv)

source("ui.R")
source("server.R")

renv::init()
shinyApp(ui, server)