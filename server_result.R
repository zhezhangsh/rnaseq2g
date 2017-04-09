server_result <- function(input, output, session, session.data) {
  
  ###################################################################################################
  ######################################## "Result" tab #############################################  
  # Load example
  observeEvent(input$result.load.example, { 
    loaded <- rnaseq2g.retrieve.result('data/result/'); 
    session.data$result <- loaded$result;
    output$result.load.info  <- renderUI(h5(HTML(loaded$message)));
    output$result.load.error <- renderUI(h5(HTML(loaded$error)));
    rnaseq2g.update.selector(session, session.data, output=output);       
  });
  
  # Load results option 1
  observeEvent(input$result.current.load, { 
    withProgress({
      loaded <- rnaseq2g.retrieve.result(session.data$dir); 
      session.data$result <- loaded$result;
      output$result.load.info  <- renderUI(h5(HTML(loaded$message)));
      output$result.load.error <- renderUI(h5(HTML(loaded$error)));
      rnaseq2g.update.selector(session, session.data, output=output);       
    }, message = "Loading results ... ...", detail = 'Please wait')
  });
  
  # Load results option 2
  observeEvent(input$result.previous.load, {
    withProgress({
      id <- input$result.previous.id; 
      loaded <- rnaseq2g.retrieve.result(paste(APP_HOME, 'log', id, sep='/'));  saveRDS(loaded, 'loaded.rds');
      session.data$result <- loaded$result;
      output$result.load.info <- renderUI(h5(HTML(loaded$message)));
      output$result.load.error <- renderUI(h5(HTML(loaded$error)));
      rnaseq2g.update.selector(session, session.data, output=output);         
    }, message = "Loading results ... ...", detail = 'Please wait')
  });
  
  # Load results option 3
  observeEvent(input$result.previous.upload, {
    if (is.null(input$result.previous.upload)) {
      msg <- '<font color="red";>No file uploaded.</font>';
    } else {
      uploaded <- input$result.previous.upload; 
      if (file.exists(uploaded$datapath)) {
        fn.res  <- paste(session.data$dir, uploaded$name, sep='/');
        file.copy(uploaded$datapath, fn.res); 

        res <- tryCatch(
          ImportR(fn.res), 
          error = function(e) {
            output$result.load.error <- renderUI(h5(HTML(paste('<font color="darkblue";>', e$message, '</font>', sep=''))));
            NA;
          },
          warning = function(w) {
            output$result.load.error <- renderUI(h5(HTML(paste('<font color="darkblue";>', w$message, '</font>', sep=''))));
            NA;
          }
        ); 
        
        if (identical(NA, res)) {
          msg <- paste('<font color="red";>Fail to upload file:</font>', uploaded$name);
        } else {
          msg <- rnaseq2g.validate.result(res); # validate uploaded file
          if (identical(NA, msg)) {
            session.data$result <- res; 
            msg <- c('<p><font color="blue";>Results successfully loaded from local file: </font></p>', 
                     rnaseq2g.summarize.result(res$input, 'user') );
            rnaseq2g.update.selector(session, session.data, output=output);
          } else {
            msg <- c('<p><font color="red">File not recognized; read [<b>Manual</b>] for detail:</font></p>', 
                     paste('<p>&nbsp&nbsp', msg, '</p>', sep=''));
          }
        }
      } else {
        msg <- paste('<font color="red";>File to upload not found:</font>', uploaded$name);
      } 
    };
    output$result.load.info <- renderUI(h5(HTML(msg)));
  });
  
  # Show stat table
  output$result.show.table <- DT::renderDataTable({
    res <- session.data$result;
    if (is.null(res) | input$result.select.table=='') NULL else {
      tbl <- res[[2]][[input$result.select.table]];
      pv  <- as.numeric(input$result.filter.p);
      fc  <- as.numeric(input$result.filter.fc);
      tbl <- tbl[tbl[, 5]<=pv & abs(tbl[,4])>=fc, , drop=FALSE];
      cnm <- colnames(tbl); 
      tbl <- data.frame(FormatNumeric(tbl[order(tbl[, 5]), , drop=FALSE])); 
      colnames(tbl) <- cnm; 
      cbind(Gene=rownames(tbl), tbl);
    }
  }, options = dt.options3, rownames=FALSE, selection = 'none', class = 'cell-border stripe');
  
  # Download results single table
  output$result.download.current <- downloadHandler(
    filename = function() {
      fmt <- input$result.download.format;
      mtd <- DeRNAseqMs[input$result.select.table, 1]; 
      if (fmt == 'R') paste(mtd, '.Rdata', sep='') else 
        if (fmt == 'Text') paste(mtd, '.txt', sep='') else 
          paste(mtd, '.xls', sep='')
    },  
    content  = function(file) { 
      res <- session.data$result;
      if (!is.null(res)) {
        tbl <- res[[2]][[input$result.select.table]];
        pv  <- as.numeric(input$result.filter.p);
        fc  <- as.numeric(input$result.filter.fc);
        tbl <- tbl[tbl[, 5]<=pv & abs(tbl[,4])>=fc, , drop=FALSE];
        fmt <- input$result.download.format;
        if (fmt == 'Excel') WriteXLS::WriteXLS(data.frame(tbl), ExcelFileName=file, SheetNames=input$result.select.table, row.names = TRUE) else 
          if (fmt == 'Text') write.table(tbl, file, sep='\t', quote = FALSE) else 
            if (fmt == 'R') save(tbl, file=file);
      }
    } 
  ); # END of download single table
  
  # Download all results
  output$result.download.all <- downloadHandler(
    filename = function() {
      fmt <- input$result.download.format;
      if (fmt == 'R') 'results.Rdata' else if (fmt == 'Text') 'results.txt' else 'results.xls' 
    },  
    content  = function(file) {
      res <- session.data$result;
      if (!is.null(res)) {
        fmt <- input$result.download.format;
        if (fmt == 'R') save(res, file=file) else
          if (fmt == 'Text') {
            tbl <- do.call('rbind', res[[2]]); 
            tbl <- data.frame(Gene=unlist(lapply(res[[2]], rownames), use.names=FALSE), tbl, 
                              Method=rep(names(res[[2]]), sapply(res[[2]], nrow)), 
                              stringsAsFactors = FALSE);
            write.table(tbl, file, sep = '\t', quote = FALSE, row.names = FALSE);
          } else
            if (fmt == 'Excel') {
              tbls <- res[[1]][1:2]; 
              tbls$normalized.count  <- res[[1]]$normalized$count;
              tbls$normalized.logged <- res[[1]]$normalized$logged;
              tbls <- c(tbls, res[[2]]);
              tbls <- lapply(tbls, as.data.frame);
              WriteXLS::WriteXLS(tbls, ExcelFileName=file, SheetNames=names(tbls), row.names = TRUE);
            }
      }
    } 
  ); # END of download all results
  
  # Plots
  output$result.show.plot <- renderPlotly({
    suppressMessages(suppressWarnings({
      rnaseq2g.plot.global(session.data$result, input$result.select.table, input$result.select.plot);
    }))
  });
  
  # Download plot
  # output$result.download.plot <- downloadHandler(
  #   filename = function() {
  #     nm <- c('1'='MA', '2'='Volcano', '3'='Pvalue', '4'='FDR')[input$result.select.plot];
  #     paste(nm, input$result.download.plottype, sep='\\.');
  #   },
  #   content  = function(file) {
  #     typ <- input$result.download.plottype;
  #     if (!is.null(typ) & typ=='pdf') pdf(file, width=4.8, height = 6) else 
  #       if (!is.null(typ) & typ=='png') png(file, width=4.8, height=6, unit='in', res=300) else
  #         if (!is.null(typ) & typ=='jpeg') jpeg(file, width=4.8, height=6, unit='in', res=300) else
  #           if (!is.null(typ) & typ=='tiff') tiff(file, width=4.8, height=6, unit='in', res=300);
  #     
  #     withProgress(
  #       message = 'Drawing plot ...', {
  #         suppressMessages(suppressWarnings({
  #           rnaseq2g.plot.global(session.data$result, input$result.select.table, input$result.select.plot);
  #           dev.off();
  #         }))
  #       }
  #     )
  #   }
  # );
  
  session.data;
}
