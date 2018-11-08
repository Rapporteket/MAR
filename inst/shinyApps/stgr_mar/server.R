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
            PDF = 'pdf', HTML = 'html', REVEAL = 'html', BEAMER = 'pdf')
    )
  }

  # render file function for re-use
  contentFile <- function(file, srcFile, tmpFile, type) {
    src <- normalizePath(system.file(srcFile, package="noric"))

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
      BEAMER = beamer_presentation(theme = "Hannover"),
      REVEAL = revealjs::revealjs_presentation(theme = "sky")
      #css = normalizePath(system.file("bootstrap.css", package = "noric")))
    ), params = list(tableFormat=switch(
      type,
      PDF = "latex",
      HTML = "html",
      BEAMER = "latex",
      REVEAL = "html")
    ), output_dir = tempdir())
    # active garbage collection to prevent memory hogging?
    gc()
    file.rename(out, file)
  }
  
  
  # output$downloadReportStentbruk <- downloadHandler(
  #   filename = function() {
  #     downloadFilename("NORIC_local_monthly_stent",
  #                      input$formatStentbruk)
  #   },
  #   
  #   content = function(file) {
  #     contentFile(file, "NORIC_local_monthly_stent.Rmd", "tmpNoricStent.Rmd",
  #                 input$formatStentbruk)
  #   }
  # )
  # 
  # output$downloadReportProsedyrer <- downloadHandler(
  #   filename = function() {
  #     downloadFilename("NORIC_local_monthly", input$formatProsedyrer)
  #   },
  #   
  #   content = function(file) {
  #     contentFile(file, "NORIC_local_monthly.Rmd", "tmpNoric.Rmd",
  #                 input$formatProsedyrer)
  #   }
  # )
})
