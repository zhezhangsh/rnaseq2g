##########################
####### RNAseq-2G ########
##########################

print("loading UI");

source("/srv/shiny-server/rnaseq_2g_zhangz/preload.R");

shinyUI(
  
  navbarPage(
    title = "RNA-seq 2G",
    id    = "main_menu",
    theme = shinytheme("united"),
    
    source('ui_analysis.R', local=TRUE)$value,
    source('ui_result.R', local=TRUE)$value,
    source('ui_compare.R', local=TRUE)$value,
    source('ui_manual.R', local=TRUE)$value
  )
) # end of shinyUI


