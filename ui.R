##########################
####### RNAseq-2G ########
##########################
#source("/srv/shiny-server/rnaseq_2g_dev/preload.R");
source("/srv/shiny-server/rnaseq_2g/preload.R");

shinyUI(
  
  navbarPage(
    title        = HTML("<b><u><i>RNA-seq 2G</i></u></b>&nbsp&nbsp", "<font color='#F0F0F0' size=1><b><i>Web portal of 2-group DE analysis</i></b></font>"),
    windowTitle  = "RNA-seq 2G", 
    id           = "main_menu",
    theme        = shinytheme("united"),
    
    source('ui_analysis.R', local=TRUE)$value,
    source('ui_result.R', local=TRUE)$value,
    source('ui_compare.R', local=TRUE)$value,
    source('ui_metaanalysis.R', local=TRUE)$value,
    source('ui_manual.R', local=TRUE)$value
  )
) # end of shinyUI


