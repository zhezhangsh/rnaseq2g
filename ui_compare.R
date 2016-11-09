#########################################################################################################    
tabPanel(
  "Comparison",
  h1(HTML('<font color="tomato" face="Comic Sans MS"><center><b>Compare methods</b></center></font>')),
  
  conditionalPanel(
    condition = 'input["compare.select.table2"] == ""', 
    h4(HTML('&nbsp&nbsp&nbsp<font color="darkgreen">Method comparison will be available when results from 2+ DE methods are available.</font>'))
  ),
  
  conditionalPanel(
    condition = 'input["compare.select.table2"] != ""', 
    wellPanel(fluidRow(
      h3(HTML('&nbsp&nbsp&nbspCompare global pattern between 2 methods')),
      column(
        6, 
        wellPanel(fluidRow(
          column(6, selectInput("compare.select.table1", label = "Select method", choices = list(), width = '75%')),
          column(6, selectInput('compare.select.plot1', 'Select plot', plot.type, selected = 1, width = '75%'))
        )),
        plotOutput('compare.show.plot1', width = '100%', height = '480px')
      ),
      column(
        6, 
        wellPanel(fluidRow(
          column(6, selectInput("compare.select.table2", label = "Select method", choices = list(), width = '75%')),
          column(6, selectInput('compare.select.plot2', 'Select plot', plot.type, selected = 1, width = '75%'))
        )),
        plotOutput('compare.show.plot2', width = '100%', height = '480px')
      )
    ))),
  # Compare rankings of two methods
  conditionalPanel(condition = 'input["compare.select.table2"] != ""', wellPanel(fluidRow(
    h3(HTML('&nbsp&nbsp&nbspCompare p values and their ranking between 2 methods')),
    column(7, DT::dataTableOutput('compare.table.pv', width='100%')),
    column(
      5,
      fluidRow(
        div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;")),
        div(style="display:inline-block;", selectInput('compare.top.gene', 'Top genes', c=c('All', 10, 25, 50, 100, 250, 500), width='100px')),
        div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")), 
        div(style="display:inline-block;", selectInput('compare.pv.type', 'Select plot', list('Quantile-quantile'='1', 'P value ranking'='2', 'Venn diagram'='3'), width='160px'))
      ),
      plotOutput('compare.plot.pv', width = '100%', height = '480px')
    )
  ))),
  # Single gene details
  conditionalPanel(condition = 'input["compare.select.table2"] != ""', wellPanel(fluidRow(
    h3(HTML("&nbsp&nbsp&nbspCompare results of a single gene between methods")),
    div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;")),
    div(style="display:inline-block;", textInput("compare.single.id", NULL, value = "")),
    div(style="display:inline-block;", HTML("&nbsp;&nbsp;&nbsp;&nbsp;")),
    div(style="display:inline-block", htmlOutput("compare.single.msg")),
    conditionalPanel(condition = 'input["compare.single.id"] != ""', 
      column(7, DT::dataTableOutput('compare.single.table', width='100%')),
      column(
        5,
        plotlyOutput('compare.single.plot', width = '100%', height = '480px'),
        h6(HTML("&nbsp;")),
        fluidRow(
          column(
            12, align='center', 
            radioButtons('compare.single.type', NULL, list('Original count'='1', 'Normalized count'='2', 'Log2-transformed'='3'), selected = '2', inline = TRUE)
          )
        )
      )
    )
  )))
)
