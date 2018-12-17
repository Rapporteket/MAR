#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(rapbase)

addResourcePath('rap', system.file('www', package='rapbase'))
regTitle <- "STYRINGSGRUPPE Modernisering av Rapporteket"

shinyUI(
  navbarPage(
    title = div(img(src="rap/logo.svg", alt="Rapporteket", height="26px"),
                regTitle),
    windowTitle = regTitle,
    theme = "rap/bootstrap.css",
    tabPanel(
      "12. november 2018",
      sidebarLayout(
        sidebarPanel(
          radioButtons('docFormat',
                       'Last ned som:',
                       c('PDF', 'HTML', 'BEAMER', 'REVEAL'),
                       inline = FALSE),
          downloadButton('downloadDoc', 'Ok'),
          width = 2
        ),
        mainPanel(
          tabsetPanel(id   = "tab",
            tabPanel("Innkalling",
                     htmlOutput("stgr1_innkalling"), value = "inn"),
            tabPanel("Saker",
                     htmlOutput("stgr1_saker"), value = "sak"),
            tabPanel("Referat")
            )
          )
      )
    ),
    tabPanel("12. februar 2019?"),
    tabPanel("12. april 2019?")
  )
)