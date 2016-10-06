rnaseq2g.run.analysis <- function(dir) {
  cmmd <- paste('Rscript --vanilla /srv/shiny-server/rnaseq_2g_zhangz/run_analysis.R', dir);
  system(cmmd, wait=FALSE, ignore.stdout = TRUE, ignore.stderr = TRUE);
}