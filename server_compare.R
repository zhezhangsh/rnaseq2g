server_compare <- function(input, output, session, session.data) {
  
  #######################################################################################################
  ######################################## "Comparison" tab #############################################
  # Plot1
  output$compare.show.plot1 <- renderPlotly({
    withProgress(
      message = 'Drawing plot ...', {
        rnaseq2g.plot.global(session.data$result, input$compare.select.table1, input$compare.select.plot1);
      }
    )
  });
  # Plot2
  output$compare.show.plot2 <- renderPlotly({
    withProgress(
      message = 'Drawing plot ...', {
        rnaseq2g.plot.global(session.data$result, input$compare.select.table2, input$compare.select.plot2);
      }
    )
  });
  
  # Concordant change of plot type
  observeEvent(input$compare.select.plot1, {
    updateSelectInput(session, 'compare.select.plot2', label = "Select plot", selected = input$compare.select.plot1);
  }); 
  observeEvent(input$compare.select.plot2, {
    updateSelectInput(session, 'compare.select.plot1', label = "Select plot", selected = input$compare.select.plot2);
  }); 
  
  # P value ranking table
  output$compare.table.pv <- DT::renderDataTable({
    res <- session.data$result;
    md1 <- input$compare.select.table1; 
    md2 <- input$compare.select.table2; 
    if (is.null(res) | md1=='' | md2=='') NULL else {
      top <- input$compare.top.gene;
      tbl <- rnaseq2g.rank.pvalue(res, c(md1, md2), DeRNAseqMs);
      if (!identical(top, 'All')) {
        n <- as.integer(top); 
        tbl <- tbl[tbl[, 1]<=n | tbl[, 2]<=n, , drop=FALSE];
      }
      tbl <- data.frame(Gene = rownames(tbl), tbl, stringsAsFactors = FALSE);
    } 
  }, options = dt.options3, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  
  # Plot p values
  output$compare.plot.pv <- renderPlotly({ 
    rnaseq2g.plot.pvalue(session.data$result, input$compare.select.table1, input$compare.select.table2, 
                         input$compare.pv.type, input$compare.top.gene, DeRNAseqMs);
  });
  
  # Single gene table
  output$compare.single.table <- DT::renderDataTable({
    gid <- input$compare.single.id; 
    res <- session.data$result; 
    if (is.null(res)) {
      output$compare.single.msg <- renderUI(HTML('<font color="darkblue";>No results available.</font>'));
      NULL;
    } else if (gid == '') {
      output$compare.single.msg <- renderUI(HTML('<font color="darkblue";>Enter gene ID.</font>'));
      NULL;
    } else if (!(gid %in% rownames(res$output[[1]]))) {
      output$compare.single.msg <- renderUI(HTML('<font color="darkblue";>Gene not found: </font>', gid));
      NULL;
    } else {
      output$compare.single.msg <- renderUI(HTML('<font color="darkblue";>Gene found: </font>', gid)); 
      tbl <- t(sapply(res[[2]], function(res) res[gid, ])); 
      cnm <- c('Method', colnames(tbl));
      cnm[3] <- 'Change';
      tbl <- data.frame(Method=DeRNAseqMs[rownames(tbl), 1], FormatNumeric(tbl), stringsAsFactors = FALSE);
      colnames(tbl) <- cnm; 
      tbl
    }
  }, options = dt.options4, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  
  # Single gene barplot
  output$compare.single.plot <- renderPlotly({
    rnaseq2g.plot.single(session.data$result, input$compare.single.id, input$compare.single.type);
  });
  
  session.data;
}
