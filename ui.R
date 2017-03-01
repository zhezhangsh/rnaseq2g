##########################
####### RNAseq-2G ########
##########################
source("/srv/shiny-server/rnaseq2g/preload.R");

shinyUI(fluidPage(
  tags$head(includeScript("google-analytics.js")),
  
  navbarPage(
    
    title = HTML("<b><u><i>RNA-seq 2G</i></u></b>", "<font color='#F0F0F0' size=1>&nbspA portal of 2-group DE analysis</font>"),
    windowTitle = "RNA-seq 2G", 
    id = "main_menu",
    theme = shinytheme("united"),

    source('ui_analysis.R', local=TRUE)$value,
    source('ui_result.R', local=TRUE)$value,
    source('ui_compare.R', local=TRUE)$value,
    source('ui_metaanalysis.R', local=TRUE)$value,
    source('ui_manual.R', local=TRUE)$value
  )
)) # end of shinyUI


