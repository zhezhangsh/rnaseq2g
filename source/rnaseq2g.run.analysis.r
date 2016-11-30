rnaseq2g.run.analysis <- function(dir, APP_HOME) {
  cmmd <- paste('Rscript --vanilla', paste(APP_HOME, 'run_analysis.R', sep='/'), dir); 
  system(cmmd, wait=FALSE, ignore.stdout = TRUE, ignore.stderr = TRUE);
}