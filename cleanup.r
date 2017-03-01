path <- "/srv/shiny-server/rnaseq2g/log";

require(RoCA);

dir1 <- paste(path, dir(path), sep='/'); 
dir2 <- lapply(dir1, function(d) paste(d, dir(d), sep='/')); 
dir2 <- as.vector(unlist(dir2)); 
fns  <- paste(dir2, 'inputs.rds', sep='/'); 
dir3 <- dir2[!file.exists(fns)]; 

sapply(dir3, function(d) system(paste('sudo rm -r', d))); 

n <- sapply(dir1, function(d) length(dir(d)));
dir1 <- dir1[n==0];
if (length(dir1)) sapply(dir1, function(d) system(paste('sudo rm -r', d))); 
