# Pre-load packages and data when this App is started
.libPaths("/home/zhangz/R/x86_64-pc-linux-gnu-library/3.3");
APP_HOME <- "/srv/shiny-server/rnaseq_2g_dev"; 
#APP_HOME <- "/srv/shiny-server/rnaseq_2g"; 

require(XML);
require(readxl);
require(shinythemes);
require(plotly); 

require(RoCA);
require(rchive);
require(awsomics);
require(DEGandMore);

# Loading housekeeping data and custom function
fn  <- paste(APP_HOME, 'source', dir(paste(APP_HOME, 'source', sep='/')), sep='/');
fnc <- sapply(fn, function(fn) if (gregexpr('\\.R$', fn, ignore.case=TRUE)>0) source(fn));

ncls <- 2; 

count_example <- readRDS(paste(APP_HOME, 'data/count_example.rds', sep='/'));
group_example <- list(Control=colnames(count_example)[1:3], Patient=colnames(count_example)[4:6]);

data(DeMethodMeta); 
DeRNAseqMs    <- DeMethodMeta;
method.group  <- c('None', 'Default', 'Fast', 'Fast + Medium', 'Fast + Mediumn + Slow', 'All');
norm.count    <- as.character(as.list(args(DeRNAseq))$norm.count)[-1];
norm.logged   <- as.character(as.list(args(DeRNAseq))$norm.logged)[-1];
meta.method   <- list(Simes='simes', Average='average', Bonferroni='bonferroni', Max='max', Min='min');

plot.type     <- list('Pvalue'=1, 'FDR'=2, 'Volcano'=3, 'M-A'=4);
button.style  <- "font-family: Courier New; color: #fff; background-color: tomato; border-color: black";

choices.pv    <- list('1' = 1, '0.5' = 0.5, '0.25' = 0.25, '0.10' = 0.1, '0.05' = 0.05, '0.01' = 0.01, '0.001' = 0.001); 
choices.fc    <- list('None' = 0, '5%' = log2(1.05), '10%' = log2(1.1), '25%' = log2(1.25), '50%' = log2(1.5), '100%' = 1,
                      '200%' = log2(3), '400%' = 2, '800%' = 3);
##########################################################################################################
# datatable options
dt.options1 <- list(
  dom = 't', scrollX = TRUE, 
  initComplete = DT::JS("function(settings, json) {",
                        "$(this.api().table().header()).css({'background-color': '#666', 'color': '#fff'});", 
                        "}"));
dt.options2 <- list(
  dom = 't', scrollX = FALSE, pageLength = 100, 
  initComplete = DT::JS("function(settings, json) {",
                        "$(this.api().table().header()).css({'background-color': '#666', 'color': '#fff'});", 
                        "}"));

dt.options3 <- list(
  scrollX = TRUE, pageLength = 12, 
  initComplete = DT::JS("function(settings, json) {",
                        "$(this.api().table().header()).css({'background-color': '#666', 'color': '#fff'});", 
                        "}"));

dt.options4 <- list(
  dom = 't', scrollX = TRUE, pageLength = 100, 
  initComplete = DT::JS("function(settings, json) {",
                        "$(this.api().table().header()).css({'background-color': '#666', 'color': '#fff'});", 
                        "}"));
