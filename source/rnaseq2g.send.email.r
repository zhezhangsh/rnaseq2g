rnaseq2g.send.email <- function(mail.to, analysis.id) {
  require(mailR)
  host.name    <- "smtp.gmail.com";
  user.name    <- "txofmitodys@gmail.com";
  password     <- "GSE42986";
  port         <- 587; #587 25 465
  ssl          <- TRUE; 
  authenticate <- FALSE;
  
  subject <- "[No Reply] RNA-seq 2G analysis is done."
  body <- c(
    paste('<p>', analysis.id, '</p>', sep=''),
    '<p><b>RNA-seq 2G</b> has finished the analysis above.</p>',
    '<p>Go to http://rnaseq2g.awsomics.org, open the <u>Result]</u> page', 
    'choose </u>Option 2</u>, and enter the analysis ID to load results.</p>'
  );
  body <- paste(body, collapse=' '); 
  
  send.mail(from = user.name, to = mail.to, subject=subject, body = body, html = TRUE, authenticate = TRUE, send = TRUE,
            smtp = list(host.name = host.name, port = port, user.name = user.name, passwd = password, ssl = TRUE));
}
