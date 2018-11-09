#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

myTitle <- HTML(paste0(icon("file-medical-alt"),
                       " STYRINGSGRUPPE Modernisering av Rapporteket"))
shinyUI(
  navbarPage(
    title = myTitle,
    theme = "bootstrap.css",
    tabPanel(
      "12. november 2018",
      sidebarLayout(
        sidebarPanel(
          radioButtons('docFormat',
                       'Last ned som:',
                       c('PDF', 'HTML', 'BEAMER', 'REVEAL', 'Word'),
                       inline = FALSE),
          downloadButton('downloadDoc', 'Ok'),
          width = 2
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Innkalling",
                     htmlOutput("stgr1_innkalling")),
            tabPanel("Saker",
                     htmlOutput("stgr1_saker")),
            tabPanel("Referat")
            )
          )
      )
    ),
    tabPanel("12. februar 2019?"),
    tabPanel("12. april 2019?")
  )
)