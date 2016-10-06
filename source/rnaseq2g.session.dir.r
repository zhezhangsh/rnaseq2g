rnaseq2g.session.dir <- function(session.data) {
  x <- rev(strsplit(session.data$dir, '/')[[1]]); 
  paste(x[2], x[1], sep='/'); 
}