#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(magrittr)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  #html rendering function for re-use
  htmlRenderRmd <- function(srcFile) {
    # set param needed for report meta processing
    params <- list(tableFormat="html")
    system.file(srcFile, package="MAR") %>%
      knitr::knit() %>%
      markdown::markdownToHTML(.,
                               options = c('fragment_only',
                                           'base64_images')) %>%
      shiny::HTML()
  }
  
  
  # output$sampleUcControl <- renderUI({
  #   selectInput(inputId = "sampleUc", label = "Sample user ctrl",
  #               choices = c("How", "it", "will", "look"))
  # })
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = 10)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  
  
  output$stgr1_innkalling <- renderUI({
    htmlRenderRmd("stgr1_innkalling.Rmd")
  })
  
  output$stgr1_saker <- renderUI({
    htmlRenderRmd("stgr1_saker.Rmd")
  })
  
  
  
  # filename function for re-use
  downloadFilename <- function(fileBaseName, type) {
    paste(paste0(fileBaseName,
                 as.character(as.integer(as.POSIXct(Sys.time())))),
          sep = '.', switch(
            type,
            PDF = 'pdf', HTML = 'html', REVEAL = 'html', BEAMER = 'pdf',
            Word = 'docx')
    )
  }
  
  # observe(
  #   print(input$tab)
  # )

  # render file function for re-use
  contentFile <- function(file, srcFile, tmpFile, type) {
    srcFile <- paste0(srcFile, ".Rmd")
    print(tmpFile)
    src <- normalizePath(system.file(srcFile, package="MAR"))

    # temporarily switch to the temp dir, in case we do not have write
    # permission to the current working directory
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src, tmpFile, overwrite = TRUE)

    library(rmarkdown)
    out <- render(tmpFile, output_format = switch(
      type,
      PDF = pdf_document(),
      HTML = html_document(),
      BEAMER = beamer_presentation(theme = "", slide_level = 2),
      REVEAL = revealjs::revealjs_presentation(theme = "sky"),
      Word = word_document()
    ), params = list(tableFormat=switch(
      type,
      PDF = "latex",
      HTML = "html",
      BEAMER = "latex",
      REVEAL = "html",
      Word = "html")
    ), output_dir = tempdir())
    # active garbage collection to prevent memory hogging?
    gc()
    file.rename(out, file)
  }
  
  output$downloadDoc <- downloadHandler(
    filename = function() {
      downloadFilename(fileBaseName=switch(
        input$tab,
        inn = "strg1_innkalling",
        sak = "strg1_saker"
      ), input$docFormat)
    },

    content = function(file) {
      contentFile(file, srcFile = switch(
        input$tab,
        inn = "stgr1_innkalling",
        sak = "stgr1_saker"
        ), tmpFile = "tmpMar.Rmd", type = input$docFormat)
    }
  )
})
