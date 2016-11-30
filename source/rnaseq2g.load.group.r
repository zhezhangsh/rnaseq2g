rnaseq2g.load.group <- function(fn.grps, input, output, session, session.data) {
  ct <- session.data$matrix; 
  
  if (is.null(ct)) {
    output$analysis.step2.error <- 
      renderUI(list(h5(HTML('<font color="red";>Step 1 not done yet! Upload a read count matrix first.</font>'))));
  } else {
    tryCatch({
      ch <- 1:ncol(ct); 
      names(ch) <- colnames(ct); 
      ch <- as.list(ch); 
      
      grps <- ImportList(fn.grps); 
      gnm1 <- names(grps)[1];
      gnm2 <- names(grps)[2];
      smp1 <- as.character(grps[[1]]);
      smp2 <- as.character(grps[[2]]); 
      smp2 <- smp2[!(smp2 %in% smp1)];
      smp1 <- smp1[smp1 %in% names(ch)];
      smp2 <- smp2[smp2 %in% names(ch)];
      
      gp <- list(c(gnm1, gnm2), list(smp1, smp2)); 

      updateTextInput(session, 'analysis.step2.groupA', label='Control group name', value=gp[[1]][1]); 
      updateTextInput(session, 'analysis.step2.groupB', label='Case group name',    value=gp[[1]][2]);
      
      updateSelectizeInput(session, 'analysis.step2.sampleA', choices = ch, selected = ch[gp[[2]][[1]]]); 
      updateSelectizeInput(session, 'analysis.step2.sampleB', choices = ch, selected = ch[gp[[2]][[2]]]); 
      # updateTextInput(session, 'analysis.step2.sampleA', label='Control samples', value=paste(gp[[2]][[1]], collapse=';'));
      # updateTextInput(session, 'analysis.step2.sampleB', label='Case samples', value=paste(gp[[2]][[2]], collapse=';'));
      
      msg <- 'Groups loaded.';
      n0 <- ncol(ct); 
      n1 <- length(smp1) + length(smp2); 
      if (n1 < n0) msg <- paste(msg, 'Some samples are not found in the read count matrix.'); 
      output$analysis.step2.error <- renderUI(list(h5(HTML('<font color="darkblue";>', msg, '</font>'))));
    }, error = function(e) {
      updateTextInput(session, 'analysis.step2.groupA', label='Control group name', value=''); 
      updateTextInput(session, 'analysis.step2.groupB', label='Case group name',    value='');
      
      updateSelectizeInput(session, 'analysis.step2.sampleA', choices = NULL); 
      updateSelectizeInput(session, 'analysis.step2.sampleB', choices = NULL); 
      # updateTextInput(session, 'analysis.step2.sampleA', label='Control samples', value='');
      # updateTextInput(session, 'analysis.step2.sampleB', label='Case samples', value='');
      
      output$analysis.step2.error <- renderUI(list(h5(HTML('<font color="red";>Loading failed: ', e$message, '</font>'))));
      NULL;
    }); 
  }
}
