server_metaanalysis <- function(input, output, session, session.data) {

  # Set up analysis
  observeEvent(input$meta.select.group, { 
    if (!is.null(session.data$result)) {
      nms <- DeRNAseqMs[names(session.data$result[[2]]), 1]; 
      if (length(nms) > 1) {
        sel <- input$meta.select.group;
        ids <- rep(FALSE, length(nms)); 
        if (sel == '2') ids <- rep(TRUE, length(nms));
        if (sel == '3') ids[sample(1:length(ids), sample(2:length(ids), 1))] <- TRUE;
        for (i in 1:length(ids))
          updateCheckboxInput(session, paste('meta.method.', nms[i], sep=''), value=ids[i]);
      }
    }
  });
  
  # Run meta-analysis
  observeEvent(input$meta.run, { 
    ms <- names(session.data$result[[2]]);
    ms <- ms[ms %in% rownames(DeRNAseqMs)]; 
    ms <- DeRNAseqMs[ms, 1]; 
    ids <- paste('meta.method.', ms, sep=''); 
    sel <- c();
    for (i in 1:length(ids)) sel[i] <- input[[ids[i]]]; 
    ms <- ms[sel]; 
    nm <- rownames(DeRNAseqMs)[DeRNAseqMs[, 1] %in% ms]; 
    if (length(ms) < 2) {      
      output$meta.run.message <- renderUI(h5(HTML('<font color="red";>Require 2 or more DE methods to run meta-analysis.</font>')));
    } else {
      withProgress(
        message = 'Running meta-analysis ...', {
          session.data$meta <- tryCatch({
            setProgress(value=0.1);
            rs <- session.data$result;
            pv <- sapply(rs[[2]][nm], function(x) x[, 5]); 
            setProgress(value=0.15);
            pc <- CombinePvalue(pv, input$meta.select.method, normalize = input$meta.normalize.p);
            setProgress(value=0.75); 
            m1 <- rowMeans(rs$input$normalized$count[, rs$input$groups[[1]], drop=FALSE]);
            m2 <- rowMeans(rs$input$normalized$count[, rs$input$groups[[2]], drop=FALSE]);
            l2 <- log2(pmax(m2, min(m2[m2>0])/2)) - log2(pmax(m1, min(m1[m1>0])/2)); 
            tb <- cbind(LogFC = l2, Rank_Combined = rank(pc), Pvalue_Combined = pc, pv); 
            tb <- FormatNumeric(tb);
            colnames(tb)[4:ncol(tb)] <- ms;
            setProgress(value=0.9);
            updateSelectInput(session, "meta.compare.method", label = 'Select method', choices = as.list(ms));

            output$meta.run.message <- renderUI(h5(HTML('Analysis is done. Please see results below.')));
            
            tb;
          }, error = function(e) {
            output$meta.run.message <- renderUI(h5(HTML('<font color="red";>Meta-analysis failed:', e$message, '</font>')));
            NULL;
          });
        }
      )
    };
  });
  
  output$meta.table.pv <- DT::renderDataTable({
    tbl <- session.data$meta;
    if (is.null(tbl)) NULL else {
      top <- input$meta.top.gene;
      if (!identical(top, 'All')) {
        n   <- as.integer(top); 
        ind <- which(colnames(tbl) == input$meta.compare.method); 
        rnk <- rank(tbl[, ind]); 
        tbl <- tbl[tbl[, 2]<=n | rnk <=n, , drop=FALSE];
      }
      tbl <- data.frame(Gene = rownames(tbl), tbl, stringsAsFactors = FALSE);
      
      tbl;
    }
  }, options = dt.options5, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  
  output$meta.plot.pv <- renderPlotly({
    suppressMessages(suppressWarnings({
      rnaseq2g.plot.meta(session.data$meta, input$meta.pv.type, input$meta.compare.method, input$meta.top.gene);
    }))
  });
  
  # Download meta-analysis result table
  output$meta.download.button <- downloadHandler(
    filename = function() {
      fmt <- input$meta.download.format;
      if (fmt == 'R') 'meta_analysis.rdata' else 
        if (fmt == 'Text') 'meta_analysis.txt' else 
          'meta_analysis.xls'
    },  
    content  = function(file) { 
      res <- session.data$meta;
      if (!is.null(res)) {
        withProgress(
          message = 'Preparing data download ...', {
            fmt <- input$meta.download.format;
            if (fmt == 'Excel') WriteXLS::WriteXLS(data.frame(res), ExcelFileName=file, SheetNames='meta_analysis', row.names = TRUE) else 
              if (fmt == 'Text') write.table(res, file, sep='\t', quote = FALSE) else 
                if (fmt == 'R') save(res, file=file);
          }
        )
      } 
    }
  ); # 
  
  # Single gene table
  output$meta.single.table <- DT::renderDataTable({
    gid <- input$meta.single.id; 
    res <- session.data$result; 
    if (is.null(res)) {
      output$meta.single.msg <- renderUI(HTML('<font color="darkblue";>No results available.</font>'));
      NULL;
    } else if (gid == '') {
      output$meta.single.msg <- renderUI(HTML('<font color="darkblue";>Enter gene ID.</font>'));
      NULL;
    } else if (!(gid %in% rownames(res$output[[1]]))) {
      output$meta.single.msg <- renderUI(HTML('<font color="darkblue";>Gene not found: </font>', gid));
      NULL;
    } else {
      output$meta.single.msg <- renderUI(HTML('<font color="darkblue";>Gene found: </font>', gid)); 
      tbl <- t(sapply(res[[2]], function(res) res[gid, ])); 
      cnm <- c('Method', colnames(tbl));
      cnm[3] <- 'Change';
      tbl <- data.frame(Method=DeRNAseqMs[rownames(tbl), 1], FormatNumeric(tbl), stringsAsFactors = FALSE);
      colnames(tbl) <- cnm; 
      tbl
    }
  }, options = dt.options4, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  
  # Single gene barplot
  output$meta.single.plot <- renderPlotly({
    suppressMessages(suppressWarnings({
      rnaseq2g.plot.single(session.data$result, input$meta.single.id, input$meta.single.type);
    }))
  });
  
  session.data;
}
