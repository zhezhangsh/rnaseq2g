#########################################################################################################    
tabPanel(
  "Result",
  h1(HTML('<font color="tomato" face="Comic Sans MS"><center><b>Browse results</b></center></font>')),
  
  conditionalPanel(
    condition = 'input["compare.select.table1"] == ""', 
    rnaseq2g.write.prompt("Results will available after being loaded.")
  ),
  
  wellPanel(
    rnaseq2g.write.header("Load results using one of these options"), br(),
    fluidRow(
      column(
        5,
        selectizeInput(
          'result.load.option', NULL, width='95%',
          choices = list('Option 1: Current online analysis' = '1', 'Option 2: Previous online analysis' = '2',
                         'Option 3: Upload results from an offline analysis' = '3')
        ),
        conditionalPanel(
          condition = 'input["compare.select.table1"] == ""',
          actionButton('result.load.example', 'Load an example', icon = icon('upload'), style=button.style2)
        )
      ),
      column(
        7, 
        conditionalPanel(
          condition = 'input["result.load.option"] == "1"',
          actionButton("result.current.load", 'Click to check status', icon("refresh"), style=button.style)
        ),
        conditionalPanel(
          condition = 'input["result.load.option"] == "2"',
          column(8, textInput("result.previous.id", NULL, value = 'Enter analysis ID ...')),
          column(4, actionButton("result.previous.load", 'Load', icon("server"), style=button.style))
        ),
        conditionalPanel(
          condition = 'input["result.load.option"] == "3"',
          fileInput(inputId = "result.previous.upload", label = NULL, width='90%')
        )
      )
    ),
    fluidRow(
      column(5, htmlOutput("result.load.error")),
      column(7, htmlOutput("result.load.info"))
    )
  ),
  
  conditionalPanel(
    condition = 'input["result.select.table"] != ""',
    wellPanel(
      rnaseq2g.write.header("List and visualize test statistics"), br(),
      fluidRow(
        div(style="display: inline-block;", h5(HTML("&nbsp&nbsp&nbsp&nbsp"))),
        div(style="display: inline-block;", selectInput("result.select.table", label = "Select method", choices=list(), width='120px')),
        div(style="display: inline-block;", h5(HTML("&nbsp"))),
        div(style="display: inline-block;", selectInput("result.filter.p", label = 'P value', choices = choices.pv, width='80px')),
        div(style="display: inline-block;", h5(HTML("&nbsp"))),
        div(style="display: inline-block;", selectInput("result.filter.fc", label = 'Change', choices = choices.fc, width='80px')),   
        div(style="display: inline-block;", h5(HTML("&nbsp&nbsp&nbsp"))),
        div(style="display: inline-block;", h5(HTML('<center><b><u>Download result</u></b></center>')),
            radioButtons('result.download.format', NULL, c('R', 'Text', 'Excel'), inline=TRUE)),
        div(style="display: inline-block;", h5(HTML("&nbsp&nbsp"))),
        div(style="display: inline-block;", 
            tags$head(tags$style(".dB{float:center;} .dB{font-family: Courier New;} .dB{background-color: tomato;} 
                                 .dB{border-color: black;} .dB{height: 80%;}")),
            downloadButton('result.download.current', label = 'Table', class = 'dB'), 
            downloadButton('result.download.all', label = 'All', class = 'dB')),
        div(style="display: inline-block;", h5(HTML("&nbsp&nbsp&nbsp"))),
        div(style="display: inline-block;", selectInput('result.select.plot', 'Select plot type', plot.type, selected = 1, width='150px'))
      ),
      fluidRow(
        column(6, wellPanel(DT::dataTableOutput('result.show.table', width='100%'))),
        column(6, wellPanel(plotlyOutput('result.show.plot', width = '100%', height = '480px'))) 
      )
    )
  )
)