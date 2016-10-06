args <- commandArgs(TRUE)[1]; 

.libPaths("/home/zhangz/R/x86_64-pc-linux-gnu-library/3.3");

fn <- paste(args, 'inputs.rds', sep='/');
if (!file.exists(fn)) {
  message <- "File of input data not exist.";
} else {
  input <- readRDS(fn); 
  
  require(DEGandMore);
  data("DeMethodMeta"); 
  
  mtrx <- list(input$filtered, input$normalized$count, input$normalized$logged);
  mthd <- input$methods;
  grps <- input$groups;
  pair <- input$paired;
  
  speed   <- DeMethodMeta[mthd, 'Speed'];
  mthd    <- mthd[order(speed)];
  
  fs <- paste(args, 'status.txt', sep='/'); 
  if (!file.exists(fs)) file.remove(fs); 
  file.create(fs);
  
  msg <- sapply(mthd, function(m) {
    lg <- DeMethodMeta[m, 'Logged'] == 'Yes';
    nm <- DeMethodMeta[m, 'Normalization'] == 'Yes';
    if (!lg & nm) d <- mtrx[[1]] else if (!lg) d <- mtrx[[2]] else d <- mtrx[[3]];

    #####################################################################
    tryCatch({
      stat <- DeWrapper(d, grps, m, pair)$results$stat[, 1:6];  
      if (lg) {
        un <- 2^mtrx[[3]];
        un <- un * (mean(mtrx[[1]], na.rm=TRUE)/mean(un, na.rm=TRUE));
        m1 <- rowMeans(un[, grps[[1]], drop=FALSE]);
        m2 <- rowMeans(un[, grps[[2]], drop=FALSE]);
        stat[, 1:3] <- cbind(m1, m2, m2-m1); 
      }; 
      saveRDS(stat, paste(args, '/', m, '.rds', sep='')); 
      write(paste(m, 1, sep='\t'), fs, append = TRUE); 
      NA;
    }, error = function(e) {
      write(paste(m, 0, sep='\t'), fs, append = TRUE); 
      paste(m, as.character(e), sep=': '); 
    }); 
    #####################################################################
  });
  
  success[is.na(msg)] <- 1; 
  sta <- cbind(mthd, as.vector(success));
  write.table(sta, paste(args, 'status.txt', sep='/'), row.names = FALSE, col.names = FALSE, sep='\t', qu=FALSE);
  
  msg <- as.vector(msg[!is.na(msg)]);
  if (length(msg) == 0) message <- '' else 
    message <- paste(gsub('\n', '', msg), collapse='\n'); 
  
  writeLines(message, paste(args, 'message.txt', sep='/'));
}

