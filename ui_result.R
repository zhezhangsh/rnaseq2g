#########################################################################################################    
tabPanel(
  "Result",
  h1(HTML('<font color="tomato" face="Comic Sans MS"><center><b>Browse results</b></center></font>')),
  wellPanel(
    fluidRow(
      h3(HTML("&nbsp&nbsp&nbspLoad results")),
      column(6, wellPanel(
        style='height: 360px',
        fluidRow( # Load results, option 1
          style='padding:15px;', 
          h5(HTML("<b>Option 1: Current online analysis</b>")),
          actionButton("result.current.load", 'Check status', icon("refresh"), width='150px', style=button.style)
        ),
        fluidRow( # Load results, option 2
          style='padding:15px;', 
          div(
            style="display: inline-block;", 
            textInput("result.previous.id", 'Option 2: Previous online analysis', value = 'Enter analysis ID ...'), width='160px'),
          div(
            style="display: inline-block;", 
            actionButton("result.previous.load", 'Load', icon("server"), width='85px', style=button.style))),
        fluidRow( # Load results, option 3
          style='padding:15px', 
          fileInput(inputId = "result.previous.upload", label = "Option 3: Upload results of an offline analysis", width='90%'))
      )),
      column(6, wellPanel(style='height: 360px',
        h5(HTML("<br><b>Loaded results:</b>")),
        htmlOutput("result.load.info"),
        br(),
        htmlOutput("result.load.error")
      ))
    )
  ),
  fluidRow( 
    column(
      7,
      conditionalPanel(condition = 'input["result.select.table"] != ""',
        wellPanel(fluidRow(
          h3(HTML("&nbsp&nbspShow and filter results")),
          div(style="display: inline-block;", h4(HTML("&nbsp&nbsp"))),
          div(style="display: inline-block;", selectInput("result.select.table", label = "Select method", choices=list(), width='120px')),
          div(style="display: inline-block;", h4(HTML("&nbsp"))),
          div(style="display: inline-block;", selectInput("result.filter.p", label = 'P value', choices = choices.pv, width='80px')),
          div(style="display: inline-block;", h4(HTML("&nbsp"))),
          div(style="display: inline-block;", selectInput("result.filter.fc", label = 'Fold change', choices = choices.fc, width='120px')),   
          div(style="display: inline-block;", h4(HTML("&nbsp&nbsp"))),
          div(style="display: inline-block;", h4(HTML('<center>Download</center>')),
              radioButtons('result.download.format', NULL, c('R', 'Text', 'Excel'), inline=TRUE)),
          div(style="display: inline-block;", h4(HTML("&nbsp"))),
          div(style="display: inline-block;", 
              tags$head(tags$style(".dB{float:center;} .dB{font-family: Courier New;} .dB{background-color: tomato;} 
                                   .dB{border-color: black;} .dB{height: 80%;} .dB{width: 120px;} .dB{font-size: 11px;}")),
              downloadButton('result.download.current', label = 'This table', class = 'dB'), 
              downloadButton('result.download.all', label = 'All results', class = 'dB')),
          p(),
          column(12, DT::dataTableOutput('result.show.table', width='100%'))
        ))
      )
    ), # End of showing table panel
    column(
      5,
      conditionalPanel(condition = 'input["result.select.table"] != ""',
        wellPanel(fluidRow(
          h3(HTML("&nbsp&nbsp&nbspPlot statistics")),
          div(style="display: inline-block;", h4(HTML("&nbsp&nbsp&nbsp"))),
          div(style="display: inline-block;", selectInput('result.select.plot', 'Select plot', plot.type, selected = 1, width='128')),
          div(style="display: inline-block;", h4(HTML("&nbsp&nbsp&nbsp&nbsp"))),
          div(style="display: inline-block;", h4(HTML('<center>Download</center>')),
              radioButtons('result.download.plottype', label = NULL, choices = c('pdf', 'png', 'tiff'), selected = 'pdf', inline=TRUE)),
          div(style="display: inline-block;", h4(HTML("&nbsp&nbsp"))),
          div(style="display: inline-block;", 
              tags$head(tags$style(".dB1{float:center;} .dB1{background-color: tomato;} .dB1{border-color: black;} .dB1{height: 80%;}")),
              downloadButton('result.download.plot', label = '', class = 'dB1')
          ), 
          p(),
          column(12, plotOutput('result.show.plot', width = '100%', height = '480px'))
        ))
      )
    ) # End of showing plot panel
  )
)