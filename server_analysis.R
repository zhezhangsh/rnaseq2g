server_analysis <- function(input, output, session, session.data) {
  
  ###################################################################################################
  ######################################## "Analysis" tab ###########################################  
  
  ###################################################################################################
  # Analysis, Step 1
  # Load an example 
  observeEvent(input$analysis.load.example, {
    session.data$matrix <- tryCatch({
      tbl <- readRDS('data/count_example.rds');
      # Table dimension
      output$analysis.step1.size <- renderUI(list(h4(HTML(paste(
        '<font color="darkgreen">The loaded matrix includes', nrow(tbl), 'rows (genes) and', ncol(tbl), 'columns (samples).</font>')))));
      
      ch <- 1:ncol(tbl); 
      names(ch) <- colnames(tbl); 
      ch <- as.list(ch);
      
      updateSelectizeInput(session, 'analysis.step2.sampleA', choices = ch, selected = 1:3); 
      updateSelectizeInput(session, 'analysis.step2.sampleB', choices = ch, selected = 4:6); 
      updateRadioButtons(session, 'analysis.step2.paired', selected = 'Unpaired');
      
      tbl;
    }, error = function(e) {
      output$analysis.step1.size <- renderUI(list(h5(HTML('<font color="red";>Loading data failed:', e$message, '</font>'))));
      NULL;
    });
    # Table header
    output$analysis.step1.table <- DT::renderDataTable({
      if (is.null(session.data$matrix)) NULL else {
        tbl <- session.data$matrix[1:min(3, nrow(session.data$matrix)), , drop=FALSE];
        data.frame(Gene=rownames(tbl), tbl, stringsAsFactors = FALSE);
      }
    }, options = dt.options1, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
    
    # select methods
    ids <- DeRNAseqMs[DeRNAseqMs$Default=='Yes', 1];
    for (i in 1:length(ids))
      updateCheckboxInput(session, paste('analysis.method.', ids[i], sep=''), value=TRUE);
    updateRadioButtons(session, 'analysis.step3.group', selected = 'Default');
  });

  # Load data matrix
  observeEvent(input$analysis.step1.upload, {
    if (is.null(input$analysis.step1.upload)) session.data$matrix <- NULL else {
      uploaded <- input$analysis.step1.upload; 
      if (file.exists(uploaded$datapath)) {
        fn.mtrx  <- paste(session.data$dir, uploaded$name, sep='/');
        file.copy(uploaded$datapath, fn.mtrx); 
        session.data$matrix <- tryCatch({
          tbl <- as.matrix(ImportTable(fn.mtrx));
          # Table dimension
          output$analysis.step1.size <- renderUI(list(h4(HTML(paste(
            '<font color="darkgreen">The loaded matrix includes', nrow(tbl), 'rows (genes) and', ncol(tbl), 'columns (samples).</font>')))));
          
          ch <- 1:ncol(tbl); 
          names(ch) <- colnames(tbl); 
          ch <- as.list(ch);
          
          updateSelectizeInput(session, 'analysis.step2.sampleA', choices = ch, selected = character(0)); 
          updateSelectizeInput(session, 'analysis.step2.sampleB', choices = ch, selected = character(0)); 
          updateRadioButtons(session, 'analysis.step2.paired', selected = 'Unpaired');

          tbl;
        }, error = function(e) {
          output$analysis.step1.size <- renderUI(list(h5(HTML('<font color="red";>Loading data failed:', e$message, '</font>'))));
          NULL;
        });
      } else session.data$matrix <- NULL
    };
    
    # Table header
    output$analysis.step1.table <- DT::renderDataTable({
      if (is.null(session.data$matrix)) NULL else {
        tbl <- session.data$matrix[1:min(3, nrow(session.data$matrix)), , drop=FALSE];
        data.frame(Gene=rownames(tbl), tbl, stringsAsFactors = FALSE);
      }
    }, options = dt.options1, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  });
  
  # Download sample data
  output$analysis.step1.txt <- downloadHandler(
    filename = function() 'count_example.txt',  
    content  = function(file) write.table(count_example, file, sep='\t', quote = FALSE)
  );
  output$analysis.step1.tsv <- downloadHandler(
    filename = function() 'count_example.tsv',  
    content  = function(file) write.table(count_example, file, sep='\t', quote = FALSE)
  );
  output$analysis.step1.csv <- downloadHandler(
    filename = function() 'count_example.csv',  
    content  = function(file) write.csv(count_example, file)
  );
  output$analysis.step1.rds <- downloadHandler(
    filename = function() 'count_example.rds',  
    content  = function(file) saveRDS(count_example, file)
  );
  output$analysis.step1.rda <- downloadHandler(
    filename = function() 'count_example.rda',  
    content  = function(file) save(count_example, file=file)
  );
  output$analysis.step1.rdata <- downloadHandler(
    filename = function() 'count_example.rdata',  
    content  = function(file) save(count_example, file=file)
  );
  output$analysis.step1.xls <- downloadHandler(
    filename = function() 'count_example.xls',  
    content  = function(file) WriteXLS::WriteXLS(data.frame(count_example), ExcelFileName=file, SheetNames='count_example', row.names = TRUE)
  );
  output$analysis.step1.xlsx <- downloadHandler(
    filename = function() 'count_example.xlsx',  
    content  = function(file) WriteXLS::WriteXLS(data.frame(count_example), ExcelFileName=file, SheetNames='count_example', row.names = TRUE)
  );
  output$analysis.step1.html <- downloadHandler(
    filename = function() 'count_example.html',  
    content  = function(file) print(xtable::xtable(count_example), type='html', file=file)
  );
  
  ###################################################################################################
  # Analysis, Step 2
  # Load sample grouping
  observeEvent(input$analysis.step2.group, {
    if (is.null(input$analysis.step2.group)) NULL else {
      uploaded <- input$analysis.step2.group; 
      
      if (file.exists(uploaded$datapath)) {
        fn.grps  <- paste(session.data$dir, uploaded$name, sep='/');
        file.copy(uploaded$datapath, fn.grps);
        rnaseq2g.load.group(fn.grps, input, output, session, session.data); 
      } else NULL
    }
  });
  
  observeEvent(input$analysis.step2.sampleA, {
    ct <- session.data$matrix; 
    if (!is.null(ct)) {
      s1 <- as.integer(input$analysis.step2.sampleA);
      s2 <- as.integer(input$analysis.step2.sampleB);
      
      ch <- 1:ncol(ct); 
      names(ch) <- colnames(ct);
      ch <- as.list(ch); 
      if (length(s1) > 0) s2 <- s2[!(s2 %in% s1)]; 

      updateSelectizeInput(session, 'analysis.step2.sampleB', selected = ch[s2]); 
    }
  });
  
  observeEvent(input$analysis.step2.sampleB, {
    ct <- session.data$matrix; 
    if (!is.null(ct)) {
      s1 <- as.integer(input$analysis.step2.sampleA);
      s2 <- as.integer(input$analysis.step2.sampleB);
      
      ch <- 1:ncol(ct); 
      names(ch) <- colnames(ct);
      ch <- as.list(ch); 
      if (length(s2) > 0) s1 <- s1[!(s1 %in% s2)]; 
      
      updateSelectizeInput(session, 'analysis.step2.sampleA', selected = ch[s1]); 
    }
  });
  
  # Download sample groups
  output$analysis.step2.txt <- downloadHandler(
    filename = function() 'group_example.txt',  
    content  = function(file) {
      lns <- sapply(names(group_example), function(nm) 
        paste(nm, paste(group_example[[nm]], collapse='\t'), sep='\t'));
      writeLines(lns, file);
    }
  );
  output$analysis.step2.csv <- downloadHandler(
    filename = function() 'group_example.csv',  
    content  = function(file) {
      lns <- sapply(names(group_example), function(nm) 
        paste(nm, paste(group_example[[nm]], collapse=','), sep=','));
      writeLines(lns, file);
    }
  );
  output$analysis.step2.rds <- downloadHandler(
    filename = function() 'group_example.rds',  
    content  = function(file) saveRDS(group_example, file)
  );
  output$analysis.step2.rdata <- downloadHandler(
    filename = function() 'group_example.rdata',  
    content  = function(file) save(group_example, file=file)
  );
  output$analysis.step2.xls <- downloadHandler(
    filename = function() 'group_example.xls',  
    content  = function(file) {
      tbl <- rbind(group_example[[1]], group_example[[2]]);
      rownames(tbl) <- names(group_example); 
      WriteXLS::WriteXLS(data.frame(tbl), ExcelFileName=file, SheetNames='group_example', 
                         row.names = TRUE, col.names = FALSE);
    }
  );
  output$analysis.step2.xlsx <- downloadHandler(
    filename = function() 'group_example.xlsx',  
    content  = function(file) {
      tbl <- rbind(group_example[[1]], group_example[[2]]);
      rownames(tbl) <- names(group_example); 
      WriteXLS::WriteXLS(data.frame(tbl), ExcelFileName=file, SheetNames='group_example', 
                         row.names = TRUE, col.names = FALSE);
    }
  );
  ###################################################################################################
  # Analysis, Step 3
  # Select method(s)  
  observeEvent(input$analysis.step3.group, {
    sel <- which(method.group == input$analysis.step3.group) - 2; 
    if (sel >= 0 & !is.na(sel) & !is.null(sel)) mth <- DeRNAseqMethods(sel) else mth <- NULL; 
    ids <- rep(FALSE, nrow(DeRNAseqMs));
    ids[DeRNAseqMs[, 1] %in% DeRNAseqMs[mth, 1]] <- TRUE;

    for (i in 1:length(ids))
      updateCheckboxInput(session, paste('analysis.method.', DeRNAseqMs[i, 1], sep=''), value=ids[i]);
  });
  
  observeEvent(input$analysis.step3.button, {session.data$show <- 1 - session.data$show;});
  output$analysis.step3.panel1 <- renderUI({
    if (session.data$show == 0) l <- 'Show method description' else l <- 'Hide method description';
    actionLink('analysis.step3.button', label = h4(HTML('<font color="blue"><u>', l, '</u></font>')));
  }); 
  output$analysis.step3.panel2 <- renderUI({
    if (session.data$show == 0) br() else DT::dataTableOutput('analysis.step3.table', width='100%')
  });
  output$analysis.step3.table <- DT::renderDataTable({
    tbl <- DeRNAseqMs[, 1:8];
    tbl[, 1] <- AddHref(tbl[, 1], DeRNAseqMs[, 10]); 
    tbl;
  }, options = dt.options2, rownames=FALSE, selection = 'none', class = 'cell-border stripe', escape=FALSE);
  
  ###################################################################################################
  # Analysis, Run
  output$analysis.id.message <- renderUI(h4(HTML(
    '<font color="black";>Analysis ID:</font><font color="green";>', rnaseq2g.session.dir(session.data), '</font>')));
  
  observeEvent(input$analysis.run, { 
    if (session.data$run == 0) {
      # updateActionButton(session, 'analysis.run', label = 'Submitting ..');
      # output$analysis.submitting.message <- renderUI(h5(HTML('<font color="red";>Submitting analysis ...</font>')));
      
      withProgress(
        message = 'Submitting analysis ...', {
          setProgress(value=0.05);
          inp <- rnaseq2g.validate.input(input, output, session, session.data); 
          setProgress(value=0.75);
          
          if(!is.null(inp)) {
            fn <- paste(session.data$dir, 'inputs.rds', sep='/'); 
            saveRDS(inp, fn); 
            setProgress(value=0.90);
            writeLines(c(session.data$id, input$analysis.send.email), paste(session.data$dir, 'email.txt', sep='/'));
            
            ################################################################################################
            # Submit analysis
            setProgress(value=0.95);
            rnaseq2g.run.analysis(session.data$dir, APP_HOME);
            session.data$run <- 1;
            ################################################################################################
          }
      })
    } else {
      output$analysis.run.message <- renderUI(h5(HTML('<font color="red";>Analysis already submitted; refressh your browser to start a new analysis session.</font>')));
    }
  });
  
  session.data;
}