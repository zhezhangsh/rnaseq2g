rnaseq2g.update.selector <- function(session, session.data, input=NA, output=NA) {
  # Update result page
  if (is.null(session.data$result)) { 
    updateSelectInput(session, "result.select.table", label = "Select method", choices=list());
    updateSelectInput(session, "compare.select.table1", label = "Select method", choices=list());
    updateSelectInput(session, "compare.select.table2", label = "Select method", choices=list());
    updateCheckboxGroupInput(session, "meta.select.box", label = "", choices = list(), selected=NULL, inline = TRUE);
    output$meta.select.box <- renderUI(br());
  }  else {
    tbl <- as.list(names(session.data$result[[2]])); 
    names(tbl) <- DeRNAseqMs[names(session.data$result[[2]]), 1];
    updateSelectInput(session, "result.select.table", label = "Select method", choices=tbl);
    updateSelectInput(session, "compare.select.table1", label = "Select method 1", choices=tbl, selected = tbl[[1]]);
    updateSelectInput(session, "compare.select.table2", label = "Select method 2", choices=tbl, selected = tbl[[length(tbl)]]);
    updateCheckboxGroupInput(session, "meta.select.box", label = "", choices = tbl, inline = TRUE);
    output$meta.select.box <- renderUI(rnaseq2g.method.checkbox(names(tbl), 'meta'));
  }
}