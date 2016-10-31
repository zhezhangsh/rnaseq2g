rnaseq2g.update.selector <- function(session, session.data) {
  # Update result page
  if (is.null(session.data$result)) {
    updateSelectInput(session, "result.select.table", label = "Select table", choices=list());
    updateSelectInput(session, "compare.select.table1", label = "Select table", choices=list());
    updateSelectInput(session, "compare.select.table2", label = "Select table", choices=list());
    #updateSelectInput(session, "meta.select.method", label = 'Select meta-analysis method:', choices = list(), width='240px')
    updateCheckboxGroupInput(session, "meta.select.box", label = "", choices = list(), selected=NULL, inline = TRUE);
  }  else {
    tbl <- as.list(names(session.data$result[[2]])); 
    names(tbl) <- DeRNAseqMs[names(session.data$result[[2]]), 1];
    updateSelectInput(session, "result.select.table", label = "Select table", choices=tbl);
    updateSelectInput(session, "compare.select.table1", label = "Select table", choices=tbl, selected = tbl[[1]]);
    updateSelectInput(session, "compare.select.table2", label = "Select table", choices=tbl, selected = tbl[[length(tbl)]]);
    #updateSelectInput(session, "meta.select.method", label = 'Select meta-analysis method:', choices = list(Average='average', Simes='simes', Bonferroni='bonferroni', Max='max', Min='min'))
    updateCheckboxGroupInput(session, "meta.select.box", label = "", choices = tbl, inline = TRUE);
  }
}