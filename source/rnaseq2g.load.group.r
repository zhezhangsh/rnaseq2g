rnaseq2g.load.group <- function(fn.grps) {
  grps <- ImportList(fn.grps); 
  gnm1 <- names(grps)[1];
  gnm2 <- names(grps)[2];
  smp1 <- as.character(grps[[1]]);
  smp2 <- as.character(grps[[2]]); 
  
  list(c(gnm1, gnm2), list(smp1, smp2)); 
}
