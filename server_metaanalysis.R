server_metaanalysis <- function(input, output, session, session.data) {

  # Set up analysis
  observeEvent(input$meta.select.group, { 
    sel <- input$meta.select.group; 
    if (is.null(session.data$result)) all <- c() else all <- names(session.data$result[[2]]);
    all <- as.list(DeRNAseqMs[rownames(DeRNAseqMs) %in% all, 1]); 
    if (sel == '1') ms <- c() else if (sel == '2') ms <- all else {
      if (length(all) >= 2) ms <- all[sample(1:length(all), sample(2:length(all), 1))] else ms <- all;
    } 
    updateCheckboxGroupInput(session, 'meta.select.box', label = '', choices = all, selected = ms, inline = TRUE);
  });
  
  # Run meta-analysis
  observeEvent(input$meta.run, { 
    ms <- input$meta.select.box;
    nm <- sapply(ms, function(x) rownames(DeRNAseqMs)[DeRNAseqMs[, 1]==x]);
    if (length(nm) < 2) {      
      output$meta.run.message <- renderUI(h5(HTML('<font color="red";>Require 2 or more DE methods to run meta-analysis.</font>')));
    } else {
      withProgress(
        message = 'Running meta-analysis ...', {
          setProgress(value=0.1);
          rs <- session.data$result; saveRDS(rs, 'rs.rds'); 
          pv <- sapply(rs[[2]][nm], function(x) x[, 5]); 
          setProgress(value=0.15);
          pc <- CombinePvalue(pv, input$meta.select.method);
          setProgress(value=0.75);
          m1 <- rowMeans(rs$input$normalized$count[, rs$input$groups[[1]], drop=FALSE]);
          m2 <- rowMeans(rs$input$normalized$count[, rs$input$groups[[2]], drop=FALSE]);
          l2 <- log2(pmax(m2, min(m2[m2>0])/2)) - log2(pmax(m1, min(m1[m1>0])/2)); 
          tb <- cbind(LogFC = l2, Rank_Combined = rank(pc), Pvalue_Combined = pc, pv); 
          tb <- FormatNumeric(tb); 
          colnames(tb)[4:ncol(tb)] <- ms;
          setProgress(value=0.9);
          updateSelectInput(session, "meta.compare.method", label = 'Select method', choices = as.list(ms));
          session.data$meta <- tb;
          
          output$meta.run.message <- renderUI(h5(HTML('Analysis is done. Please see results below.')));
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
  }, options = dt.options3, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  
  output$meta.plot.pv <- renderPlot({
    rnaseq2g.plot.meta(session.data$meta, input$meta.pv.type, input$meta.compare.method, input$meta.top.gene);
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
  output$meta.single.plot <- renderPlot({
    rnaseq2g.plot.single(session.data$result, input$meta.single.id, input$meta.single.type);
  });
  
  session.data;
}
