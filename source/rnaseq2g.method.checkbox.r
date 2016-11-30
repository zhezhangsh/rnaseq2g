rnaseq2g.method.checkbox <- function(nm, pre='analysis') {
  nm1 <- paste(pre, '.method.', nm, sep=''); 
  lns <- paste('div(style="display: inline-block; width: 100px; height: 10px", checkboxInput("', nm1, '", "', nm, '"))', sep=''); 
  lns[-length(lns)] <- paste(lns[-length(lns)], ',', sep=''); 
  lns <- c('fluidRow(column(12, ', lns, '))'); 
  # writeLines(lns, 'ui_analysis_methods.R'); 
  eval(parse(text=lns)); 
}

rnaseq2g.method.condition <- function(nm, pre='analysis') {
  nm1 <- paste(pre, '.method.', nm, sep=''); 
  nm1 <- paste('input["', nm1, '"]', sep='');
  paste(nm1, collapse=' || '); 
}