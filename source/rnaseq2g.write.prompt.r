rnaseq2g.write.prompt <- function(msg) {
  ln <- c('div(style="border-radius:2px; border:white 0px solid; text-align:center; background:darkgrey; padding: .1cm .5cm; color:white", ', 
          'h4(HTML("', msg, '")))'); 
  ln <- paste(ln, collapse='');
  eval(parse(text=ln)); 
}

rnaseq2g.write.header <- function(msg) {
  ln <- c('div(style="border-radius:5px; border:darkgrey 2px outset; background:lightseagreen; height:48px; padding: 0.05cm .5cm; color:white", ', 
          'h4(HTML("', msg, '")))');
  ln <- paste(ln, collapse='');
  eval(parse(text=ln)); 
}