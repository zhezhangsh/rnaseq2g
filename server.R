print("starting server");

source('server_analysis.R', local=TRUE);
source('server_result.R',   local=TRUE);
source('server_compare.R',  local=TRUE);
source('server_manual.R',  local=TRUE);

options(shiny.maxRequestSize=64000000); 

shinyServer(function(input, output, session) {
  cat("new visitor: ", session$token, '\n');

  sid <- paste(Sys.Date(), session$token, sep='/');
  dir <- paste(APP_HOME, 'log', sid, sep='/');
  session.data <- reactiveValues(id = sid, dir = dir, show = 0, run = 0, matrix = NULL, result = NULL);
  if (!file.exists(dir)) dir.create(dir, recursive = TRUE);

  session.data <- server_analysis(input, output, session, session.data);
  session.data <- server_result(input, output, session, session.data);
  session.data <- server_compare(input, output, session, session.data);
  session.data <- server_manual(input, output, session, session.data);
});

