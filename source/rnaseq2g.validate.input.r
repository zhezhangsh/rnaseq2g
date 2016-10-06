rnaseq2g.validate.input <- function(input, output, session, session.data) {
  # Collect inputs and parameters
  mtrx <- session.data$matrix;
  mthd <- input$analysis.step3.selection; 
  smp1 <- strsplit(input$analysis.step2.sampleA, '[\t ;,]')[[1]];
  smp2 <- strsplit(input$analysis.step2.sampleB, '[\t ;,]')[[1]];
  grps <- list(smp1, smp2);
  pair <- input$analysis.step2.paired; 
  miss <- input$analysis.step2.missing;
  mnct <- input$analysis.step2.filter;
  norm <- c(input$analysis.step2.norm1, input$analysis.step2.norm2); 
  
  names(grps) <- c(input$analysis.step2.groupA, input$analysis.step2.groupB); 
  input <- list(original = mtrx);
  
  # Run DE
  if (is.null(mtrx)) {
    msg <- 'No read count matrix loaded, please finish step 1'; 
    output$analysis.run.message <- renderUI(HTML('<font color="red";>', msg, '</font>'));
    session.data$result <- NULL;      
  } else if (length(smp1)==0 | length(smp2)==0) {
    if (length(smp1) == 0) msg <- 'No samples in group 1, please finish step 2' else 
      msg <- 'No samples in group 2, please finish step 2'
    output$analysis.run.message <- renderUI(HTML('<font color="red";>', msg, '</font>'));
    session.data$result <- NULL;
  } else if (is.null(mthd)) {
    msg <- 'No DE methods selected, please finish step 3'; 
    output$analysis.run.message <- renderUI(HTML('<font color="red";>', msg, '</font>'));
    session.data$result <- NULL;   
  } else {
    if (pair == 'Paired') pair <- TRUE else pair <- FALSE;
    grps <- lapply(grps, function(g) g[g %in% colnames(mtrx)]);
    nums <- sapply(grps, length); 
    mthd <- rownames(DeRNAseqMs)[DeRNAseqMs[[1]] %in% mthd];
    
    # Filtering
    if (miss == 'Remove gene') mtrx <- mtrx[!is.na(rowSums(mtrx)), , drop=FALSE] else mtrx[is.na(mtrx)] <- 0;
    mtrx <- mtrx[rowSums(mtrx) >= mnct, , drop=FALSE];
    
    # Something else is wrong
    if (nrow(mtrx) < 20) { # arbitrary number
      msg <- 'Not enough genes left after filtering, require at least 20 to run DE analysis';
    } else if (nums[1]<2 | nums[2] <2) {
      msg <- 'Not enough samples to run DE analysis, require at least 2 in both groups';
    } else if (pair & nums[1]!=nums[2]) {
      msg <- paste('Paired test selected, but groups have unequal number of samples:', nums[1], 'vs.', nums[2]); 
    } else {# everything is fine
      msg <- NA;
    }
  }
  
  if (!is.na(msg)) {
    output$analysis.run.message <- renderUI(h5(HTML('<font color="red";>', msg, '</font>')));
    session.data$result <- NULL;
    NULL; 
  } else {
    output$analysis.run.message <- 
      renderUI(HTML('Congratulations! Your analysis has been successfully submitted.', 
                    'Please go to the <font color="blue"> [Result] </font> page to retrieve results'));

    input$filtered       <- mtrx;
    input$normalized     <- rnaseq2g.normalize.data(mtrx, norm); 
    input$methods        <- mthd;
    input$groups         <- grps;
    input$paired         <- pair;
    input$minimal.count  <- mnct;
    input$number.cluster <- 1;
    input$normalization  <- norm;
    
    input;
  }
}

rnaseq2g.normalize.data <- function(mtrx, norm) {
  norm1 <- paste('Norm', norm[1], sep='');
  norm2 <- paste('Norm', norm[2], sep='');
  
  d1 <- NormWrapper(mtrx, norm1);
  if (norm2 %in% c('NormVST', 'NormRlog')) d2 <- NormWrapper(mtrx, norm2) else {
    d2 <- mtrx;
    d2[d2==0] <- 1/3;
    d2 <- log2(d2); 
    d2 <- NormWrapper(d2, norm2);       
  }
  
  list(count = d1, logged = d2); 
}