#########################################################################################################
tabPanel(
  "Meta-analysis", 
  h1(HTML('<font color="tomato" face="Comic Sans MS"><center><b>Meta-analysis</b></center></font>')),
  
  conditionalPanel(
    condition = 'input["compare.select.table2"] == ""', 
    h4(HTML('&nbsp&nbsp&nbsp<font color="darkgreen">Meta-analysis will be available when results from 2+ DE methods are available.</font>'))
  ),

  conditionalPanel(
    condition = 'input["compare.select.table2"] != ""', 
    wellPanel(fluidRow(
      column(
        12, 
        div(style="display: inline-block;", h5(HTML("<b>Select DE methods to be included in meta-analysis:</b>"))),
        div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
        div(style="display: inline-block;", radioButtons('meta.select.group', '', list('Select none'=1, 'Select all'=2, 'Select random'=3), inline = TRUE))
      ),
      column(12, wellPanel(checkboxGroupInput('meta.select.box', label = "", choices = list(), inline = TRUE))),
      column(
        12, 
        div(style="display: inline-block;", 
            selectizeInput('meta.select.method', label = 'Select meta-analysis method', width='240px', 
                           choices = list(Simes='simes', Fisher='fisher', Average='average', Bonferroni='bonferroni', Max='max', Min='min'))),
        div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp")),
        div(style="display: inline-block;", checkboxInput('meta.normalize.p', label='Normalize p values first', value=TRUE))
      ),
      column(
        12,
        div(style="display: inline-block;", actionButton("meta.run", 'Run ', icon("paper-plane"), style=button.style, width='108px')),
        div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
        div(style="display: inline-block;", htmlOutput("meta.run.message"))
      )
    ))
  ),
  
  # Compare rankings of two methods
  conditionalPanel(
    condition = 'input["meta.compare.method"] != ""', 
    wellPanel(
      h3(HTML('&nbsp&nbsp&nbspCompare meta-analysis and individual DE methods')),
      fluidRow(column(
        12, 
        div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;")),
        div(style="display:inline-block;", selectInput('meta.pv.type', 'Select plot', list('Quantile-quantile'='1', 'P value ranking'='2', 'Venn diagram'='3'), width='200px')),
        div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")),
        div(style="display:inline-block;", selectInput('meta.compare.method', 'Select method', choices=list(), width='150px')),
        div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")),
        div(style="display:inline-block;", selectInput('meta.top.gene', 'Top genes', c=c('All', 10, 25, 50, 100, 250, 500), width='120px')),
        
        div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")),
        div(style="display: inline-block;", h4(HTML('<center>Download table</center>')),
            radioButtons('meta.download.format', NULL, c('R', 'Text', 'Excel'), inline=TRUE)),
        div(style="display: inline-block;", h4(HTML("&nbsp;&nbsp;"))),
        div(style="display: inline-block;", 
            tags$head(tags$style(".dC{float:center;} .dC{font-family: Courier New;} .dC{background-color: tomato;} .dC{border-color: black;} .dC{height: 75%;} .dC{width: 50px;} .dC{font-size: 11px;}")),
            downloadButton('meta.download.button', label = '', class = 'dC'))
      )),
      hr(),
      fluidRow(
        column(5, plotOutput('meta.plot.pv', width = '100%', height = '560px')),
        column(7, DT::dataTableOutput('meta.table.pv', width='100%'))
      )
    )
  ),
  
  # Single gene details
  conditionalPanel(condition = 'input["meta.compare.method"] != ""', wellPanel(fluidRow(
    h3(HTML("&nbsp&nbsp&nbspShow all results of a single gene")),
    div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;")),
    div(style="display:inline-block;", textInput("meta.single.id", NULL, value = "")),
    div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;")),
    div(style="display:inline-block", htmlOutput("meta.single.msg")),
    conditionalPanel(
      condition = 'input["meta.single.id"] != ""', 
      column(7, DT::dataTableOutput('meta.single.table', width='100%')),
      column(
        5,
        plotlyOutput('meta.single.plot', width = '100%', height = '480px'),
        h6(HTML("&nbsp;")),
        fluidRow(
          column(
            12, align='center', 
            radioButtons('meta.single.type', NULL, list('Original count'='1', 'Normalized count'='2', 'Log2-transformed'='3'), selected = '2', inline = TRUE))
          )
      )
    )
  )))
)