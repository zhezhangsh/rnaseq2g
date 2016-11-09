#########################################################################################################
tabPanel(
  "Analysis", 
  h1(HTML('<font color="tomato" face="Comic Sans MS"><center><b>Run analysis</b></center></font>')),
  
  #########################################################################
  #***** STEP 1 ******#
  wellPanel(
    h4(HTML('Step 1. Upload a read count matrix')),
    p(HTML(" - Rows and columns are correspondingly genes and samples.")), 
    div(style="display: inline-block;", HTML(" - Accept ")),
    div(style="display: inline-block;", downloadLink('analysis.step1.txt', '.txt, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.tsv', '.tsv, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.csv', '.csv, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.rds', '.rds, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.rdata', '.rdata, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.rda', '.rda, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.xlsx', '.xlsx, ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.xls', '.xls, ')),
    div(style="display: inline-block;", HTML('or ')),
    div(style="display: inline-block;", downloadLink('analysis.step1.html', '.html ')),
    div(style="display: inline-block;", HTML('file.')),
    div(style="display: inline-block;", HTML("(Click links to download sample data)")),
    p(),
    
    fluidRow(column(6, fileInput(inputId = 'analysis.step1.upload', label = NULL))),
    p(),
    
    h5(HTML('Loaded data:')),
    wellPanel(
      DT::dataTableOutput('analysis.step1.table', width='100%'),  
      htmlOutput('analysis.step1.size')
    )  
  ),    
  
  #########################################################################
  #***** STEP 2 ******#
  # groups, paired, missing value, normalization
  wellPanel(
    h4(HTML('Step 2. Set analysis parameters')),
    p(HTML(" - Sample names must match column names in matrx.")), 
    p(HTML(" - Paired test requires the same number of samples in both group.")), 
    p(HTML(" - Paired test requires the paired samples to be in the same order.")), 
    p(HTML(" - Genes with total read counts less than the minimum will be excluded from the results.")), 
    p(HTML(" - Normalization will only applied to methods without their own internal normalization.")),         
    
    wellPanel(fluidRow(
      h4(HTML('&nbsp&nbsp&nbspUpload a file or type in the group and sample names:')),
      column(
        4, 
        div(style="display: inline-block;", HTML(" - Accept ")),
        div(style="display: inline-block;", downloadLink('analysis.step2.txt', '.txt, ')),
        div(style="display: inline-block;", downloadLink('analysis.step2.csv', 'csv, ')),
        div(style="display: inline-block;", downloadLink('analysis.step2.rds', '.rds, ')),
        div(style="display: inline-block;", downloadLink('analysis.step2.rdata', '.rdata, ')),
        div(style="display: inline-block;", downloadLink('analysis.step2.xls', '.xls, ')),
        div(style="display: inline-block;", HTML('or ')),
        div(style="display: inline-block;", downloadLink('analysis.step2.xlsx', '.xlsx ')),
        div(style="display: inline-block;", HTML('file.')), 
        p(),
        fileInput(inputId = 'analysis.step2.group', label = NULL),
        htmlOutput('analysis.step2.error')
      ),
      column(
        8, 
        fluidRow(
          div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
          div(style="display: inline-block; width: 25%",
              textInput(inputId = 'analysis.step2.groupA', label = 'Control group name', value='Control')),
          div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
          div(style="display: inline-block; width: 66%", 
              textInput(inputId = 'analysis.step2.sampleA', label = 'Control samples', value=''))
        ),
        fluidRow(
          div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
          div(style="display: inline-block; width: 25%",
              textInput(inputId = 'analysis.step2.groupB', label = 'Case group name', value='Case')),
          div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
          div(style="display: inline-block; width: 66%",
              textInput(inputId = 'analysis.step2.sampleB', label = 'Case samples', value=''))
        )
      )
    )),
    p(),
    fluidRow(
      div(style="display: inline-block; width:30px", HTML("")),
      div(style="display: inline-block; width: 200px", 
          radioButtons('analysis.step2.paired', label = 'Paired test', choices = c('Unpaired', 'Paired'), inline = TRUE)),
      div(style="display: inline-block; width:10px", HTML("")),
      div(style="display: inline-block; width: 240px", 
          radioButtons('analysis.step2.missing', label = 'Missing value', choices = c('Remove gene', 'Replace with 0'), inline = TRUE)),
      
      div(style="display: inline-block; width:20px", HTML("")),
      div(style="display: inline-block; width: 160px", 
          selectizeInput('analysis.step2.norm1', label = 'Normalize count', choices = norm.count)),
      div(style="display: inline-block; width:10px", HTML("")),
      div(style="display: inline-block; width: 160px", 
          selectizeInput('analysis.step2.norm2', label = 'Normalize logged', choices = norm.logged))
    ),
    fluidRow(
      div(style="display: inline-block; width:30px", HTML("")),
      div(style="display: inline-block; align: center; width: 800px", sliderInput('analysis.step2.filter', label = 'Minimal read count', 0, 120, 6, 1))
    )
  ), # End of step2 panel
  
  #########################################################################
  #***** STEP 3 ******#
  # groups, paired, missing value, normalization
  wellPanel(
    h4(HTML('Step 3. Choose one or multiple methods')),
    p(HTML(" - The default methods take about 1 minute to finish.")), 
    p(HTML(" - Please be patient if you choose any slow methods.")), 
    
    #uiOutput('analysis.step3.sel'),
    wellPanel(
      checkboxGroupInput('analysis.step3.selection', label = "Select DE methods", choices = DeRNAseqMs[[1]], selected = NULL, inline = TRUE),
      hr(),
      radioButtons('analysis.step3.group', 'Or pick a method group:', method.group, inline = TRUE, width = '90%')
    ),
    
    uiOutput('analysis.step3.panel1'),
    uiOutput('analysis.step3.panel2')
  ),
  
  #########################################################################
  p(),
  wellPanel(fluidRow(
    column(12, htmlOutput("analysis.submitting.message")),
    column(12, htmlOutput("analysis.run.message")),
    div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
    div(style="display: inline-block;", actionButton("analysis.run", 'Submit DE analysis', width='240px', icon("paper-plane"), style=button.style)),
    div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
    div(style="display: inline-block;", htmlOutput("analysis.id.message")),
    hr(),
    column(
      12,
      div(style="display: inline-block;", textInput('analysis.send.email', label=NULL, width='240px')),
      div(style="display: inline-block;", HTML("&nbsp&nbsp&nbsp")),
      div(style="display: inline-block;",
          HTML("<font size='3'>Send a notice to this email address after the analysis is done (optional).</font>"))
    )
  ))
)