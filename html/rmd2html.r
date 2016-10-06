knitr::knit('index.Rmd', 'index.md');
rmarkdown::render('index.md', output_format = 'html_document', output_file = 'index.html', output_options = list(self_contained=TRUE));
