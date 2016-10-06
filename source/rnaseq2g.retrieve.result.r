rnaseq2g.retrieve.result <- function(dir) {
  dir <- gsub(' ', '', dir); 
  dir <- gsub('//', '/', dir); 
  dir <- gsub('/$', '', dir); 

  err <- '';
  res <- NULL;
  id  <- paste(rev(strsplit(dir, '/')[[1]])[2:1], collapse='/');
  if (!dir.exists(dir)) {
    msg <- paste('<font color="red">Analysis not found: </font><font color="darkgreen"><b>', id, '</b></font>', sep='');
  } else {
    fn <- paste(dir, 'inputs.rds', sep='/'); 
    if (!file.exists(fn)) {
      msg <- c('<font color="red">Input data not found; please make sure an analysis is submitted.</font>');
    } else {
      inp <- readRDS(fn); 
      mth <- inp$methods; 
      fns <- paste(dir, '/', mth, '.rds', sep='');  
      fn0 <- fns[file.exists(fns)]; 
      mts <- mth[file.exists(fns)]; 
      
      if (length(fn0) == 0) {
        msg <- "None of the selected DE methods have available results.";
        res <- NULL; 
      } else {
        if (length(fns) == 1) {
          msg <- "The single selected DE method has been finished"
        } else if (length(fn0) == length(fns)) {
          msg <- paste('All', length(fns), 'selected DE methods have available results.')
        } else if (length(fn0) == 1) {
          msg <- paste('1 of', length(fns), 'selected DE methods has available results.')
        } else {
          msg <- paste(length(fn0), 'of', length(fns), 'selected DE methods has available results.')
        }
        msg <- c(paste('<p><font color="blue">', msg, '</font></p>', sep=''), rnaseq2g.summarize.result(inp, id));
        
        fn <- paste(dir, 'status.txt', sep='/');
        if (file.exists(fn)) {
          ln <- readLines(fn);
          if (length(ln) == length(mth)) 
            msg <- c(msg, '<p><font color="blue"><u>The analysis has finished all DE methods!</u></font></p>');
        }
            
        stat <- lapply(fn0, readRDS); 
        names(stat) <- mts; 
        res <- list(input = inp, output = stat); 
      }
      
      # Read in runtime status and errors
      fn <- paste(dir, 'status.txt', sep='/');
      if (file.exists(fn)) {
        ln <- readLines(fn);
        st <- as.integer(sapply(strsplit(ln, '\t'), function(x) x[2]));
        st <- st[st==0]; 
        if (length(st) == 0) e <- '<font color="darkgreen">None of the DE methods generated errors.</font>' else 
          if (length(st) == 1) e <- '<font color="red">One of the DE methods generated errors:</font>' else
              e <- paste('<font color="red">', length(st), 'of the DE methods generated errors:</font>', sep='');
        err <- c(err, paste('<p>', e, '</p>', sep=''));
      }
      fn <- paste(dir, 'message.txt', sep='/'); 
      if (file.exists(fn)) {
        ln <- readLines(fn);
        ln <- ln[ln!='']; 
        if (length(ln) > 0) err <- c(err, paste('<p>&nbsp&nbsp', ln, '</p>', sep=''));
      } 
    }
  }
  
  err <- err[err!=''];
  
  list(message = msg, error = err, result = res); 
}

rnaseq2g.summarize.result <- function(inp, id) {
  c(
    paste('<p>&nbsp&nbspAnalysis ID: ', '<font color="darkgreen"><b>', id, '</b></font></p>', sep=''),
    paste('<p>&nbsp&nbspNumber of DE methods: ', '<font color="darkgreen"><b>', length(inp$methods), '</b></font></p>', sep=''),
    paste('<p>&nbsp&nbspNumber of samples: ', '<font color="darkgreen"><b>', ncol(inp$filtered), '</b></font></p>', sep=''),
    paste('<p>&nbsp&nbspNumber of genes: ', '<font color="darkgreen"><b>', nrow(inp$filtered), '</b></font></p>', sep='')
  )
}