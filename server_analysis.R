server_analysis <- function(input, output, session, session.data) {
  
  ###################################################################################################
  ######################################## "Analysis" tab ###########################################  
  
  ###################################################################################################
  # Analysis, Step 1
  
  # Load data matrix
  observeEvent(input$analysis.step1.upload, {
    if (is.null(input$analysis.step1.upload)) session.data$matrix <- NULL else {
      uploaded <- input$analysis.step1.upload; 
      if (file.exists(uploaded$datapath)) {
        fn.mtrx  <- paste(session.data$dir, uploaded$name, sep='/');
        file.copy(uploaded$datapath, fn.mtrx); 
        session.data$matrix <- as.matrix(ImportTable(fn.mtrx)); 
      } else session.data <- NULL
    }
    
    # Table header
    output$analysis.step1.table <- DT::renderDataTable({
      if (is.null(session.data$matrix)) NULL else {
        tbl <- session.data$matrix[1:min(3, nrow(session.data$matrix)), , drop=FALSE];
        data.frame(Gene=rownames(tbl), tbl, stringsAsFactors = FALSE);
      }
    }, options = dt.options1, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
    
    # Table dimension
    output$analysis.step1.size <- renderUI({
      if (is.null(session.data$matrix)) '' else 
        list(h4(HTML(paste('<font color="darkgreen">The loaded matrix includes', nrow(session.data$matrix), 
                           'rows (genes) and', ncol(session.data$matrix), 'columns (samples).</font>'))))
    });
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
        grps <- ImportList(fn.grps); 
        updateTextInput(session, 'analysis.step2.groupA', label='', value=names(grps)[1]); 
        updateTextInput(session, 'analysis.step2.groupB', label='', value=names(grps)[2]);
        updateTextInput(session, 'analysis.step2.sampleA', label='', value=paste(grps[[1]], collapse=';'));
        updateTextInput(session, 'analysis.step2.sampleB', label='', value=paste(grps[[2]], collapse=';'));
      } else NULL
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
    
    updateCheckboxGroupInput(session, 'analysis.step3.selection', label = 'Select DE methods:', 
                             choices = DeRNAseqMs[[1]], selected = DeRNAseqMs[mth, 1], inline = TRUE); 
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
      inp <- rnaseq2g.validate.input(input, output, session, session.data); 
      
      if(!is.null(inp)) {
        fn <- paste(session.data$dir, 'inputs.rds', sep='/'); 
        saveRDS(inp, fn); 
        writeLines(c(session.data$id, input$analysis.send.email), paste(session.data$dir, 'email.txt', sep='/'));

        ################################################################################################
        # Submit analysis
        rnaseq2g.run.analysis(session.data$dir)
        session.data$run <- 1;
        ################################################################################################
      }
    } else {
      output$analysis.run.message <- renderUI(h5(HTML('<font color="red";>Analysis already submitted; refressh your browser to start a new analysis session.</font>')));
    }
  });
  
  session.data;
}