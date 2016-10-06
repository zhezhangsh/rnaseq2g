##########################
####### RNAseq-2G ########
##########################

print("loading UI");

source("/srv/shiny-server/rnaseq_2g/preload.R");

shinyUI(
  
  navbarPage(
    title = HTML("<u><i>RNA-seq 2G</i></u>&nbsp&nbsp",
                 "<font color='white' size=1>A web portal of 2-group differential expression</font>"),
    id    = "main_menu",
    theme = shinytheme("united"),
    
    source('ui_analysis.R', local=TRUE)$value,
    source('ui_result.R', local=TRUE)$value,
    source('ui_compare.R', local=TRUE)$value,
    source('ui_manual.R', local=TRUE)$value
  )
) # end of shinyUI


