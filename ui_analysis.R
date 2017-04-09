#########################################################################################################
tabPanel(
  "Analysis", 
  h1(HTML('<font color="tomato" face="Comic Sans MS"><center><b>Run analysis</b></center></font>')),
  
  conditionalPanel(
    condition = 'input["analysis.step2.paired"] == null',
    rnaseq2g.write.prompt("Set up an analysis in 3 steps.")
  ),
  
  #########################################################################
  #***** STEP 1 ******#
  wellPanel(
    rnaseq2g.write.header("Step 1. Upload a read count matrix"),
    
    checkboxInput('analysis.step1.instruction', HTML('<u>Show instruction</u>'), value = TRUE),
    
    conditionalPanel(
      condition = 'input["analysis.step1.instruction"] == true',
      style = 'padding: 5px', 
      
      div(
        style="display: inline-block; width: 78%", 
        p(HTML(" - Count matrix can be obtained using tools such as <b>HTSeq-count</b> and <b>featureCounts</b>.")),
        p(HTML(" - Unique gene IDs as row names and sample IDs as column names. (<b>Important! Unidentify sample IDs</b>)")), 
        div(style="display: inline-block;", HTML(" - Accepted file formats: ")),
        div(style="display: inline-block;", downloadLink('analysis.step1.txt', '.txt, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.tsv', '.tsv, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.csv', '.csv, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.rds', '.rds, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.rdata', '.rdata, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.rda', '.rda, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.xlsx', '.xlsx, ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.xls', '.xls, ')),
        div(style="display: inline-block;", HTML('and ')),
        div(style="display: inline-block;", downloadLink('analysis.step1.html', '.html.')),
        div(style="display: inline-block;", HTML(' (Click to download example)'))
      ),
      div(style="display: inline-block; width: 1%", h6(HTML(''))),
      div(
        style="display: inline-block; width: 15%; vertical-align: top", 
        actionButton('analysis.load.example', 'Load an example', icon = icon('upload'), style=button.style2)
      ), br(), br()
    ),
    
    fluidRow(column(6, fileInput(inputId = 'analysis.step1.upload', label = NULL))),

    conditionalPanel(
      condition = 'input["analysis.step2.paired"] == "Unpaired" || input["analysis.step2.paired"] == "Paired"',
      h5(HTML('Loaded data:')),
      DT::dataTableOutput('analysis.step1.table', width='100%'),  
      htmlOutput('analysis.step1.size')
    )
  ),    
  
  #########################################################################
  #***** STEP 2 ******#
  # groups, paired, missing value, normalization
  conditionalPanel(
    condition = 'input["analysis.step2.paired"] == "Unpaired" || input["analysis.step2.paired"] == "Paired"',
    wellPanel(
      rnaseq2g.write.header("Step 2. Specify analysis parameters"), 
      
      checkboxInput('analysis.step2.instruction', HTML('<u>Show instruction</u>')),
      
      conditionalPanel(
        condition = 'input["analysis.step2.instruction"] == true',
        style = 'padding: 5px', 
        
        p(HTML(" - Sample names must match column names in matrx.")), 
        p(HTML(" - Paired test requires the same number of samples in both group.")), 
        p(HTML(" - Paired test requires the paired samples to be in the same order.")), 
        p(HTML(" - Genes with total read counts less than the minimum will be excluded from the results.")), 
        p(HTML(" - Normalization will only applied to methods without their own internal normalization."))
      ),
      
      wellPanel(
        style = "border-color: darkgrey; border-style: dashed",
        fluidRow(
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
            3,
            textInput(inputId = 'analysis.step2.groupA', label = 'Control group name', value='Control'),
            textInput(inputId = 'analysis.step2.groupB', label = 'Case group name', value='Case')
          ),
          
          column(
            5,
            selectizeInput('analysis.step2.sampleA', 'Control samples', NULL, multiple=TRUE),
            selectizeInput('analysis.step2.sampleB', 'Case samples', NULL, multiple=TRUE)
          )
        )
      ), br(),

      fluidRow(
        div(style="display: inline-block; width:30px", HTML("")),
        div(style="display: inline-block; width: 200px", 
            radioButtons('analysis.step2.paired', label = 'Paired test', choices = c('Unpaired', 'Paired'), selected=character(0),  inline = TRUE)),
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
        div(style="display: inline-block; align: center; width: 90%", sliderInput('analysis.step2.filter', label = 'Minimal read count', 0, 300, 6, 1))
      )
    )
  ), # End of step2 panel
  
  #########################################################################
  #***** STEP 3 ******#
  # groups, paired, missing value, normalization
  conditionalPanel(
    condition = 'input["analysis.step2.sampleB"] != null',
    wellPanel(
      rnaseq2g.write.header("Step 3. Choose one or multiple DE methods"), 

      checkboxInput('analysis.step3.instruction', HTML('<u>Show instruction</u>')),
      
      conditionalPanel(
        condition = 'input["analysis.step3.instruction"] == true',
        style = 'padding: 5px', 

        p(HTML(" - Choose one or more DE methods using the check boxes.")), 
        p(HTML(" - The default methods take about 1 minute in total.")), 
        p(HTML(" - Save analysis ID to retrieve results later when using any slow methods.")),
        
        h3(HTML("<b>Method description</b>")),
        DT::dataTableOutput('analysis.step3.methods', width='100%')
      ),
      
      #uiOutput('analysis.step3.sel'),
      wellPanel( 
        style = "border-color: darkgrey; border-style: dashed", 
        rnaseq2g.method.checkbox(DeRNAseqMs[, 1])
        # source('ui_analysis_methods.R', local=TRUE)$value
        # checkboxGroupInput('analysis.step3.selection', label = "Select DE methods", choices = DeRNAseqMs[[1]], selected = NULL, inline = TRUE),
      ),
      radioButtons('analysis.step3.group', 'Or pick a method group:', method.group, inline = TRUE, width = '90%')
      
      # uiOutput('analysis.step3.panel1'),
      # uiOutput('analysis.step3.panel2')
    )
  ),
  
  #########################################################################
  p(),
  conditionalPanel(
    condition = rnaseq2g.method.condition(DeRNAseqMs[[1]]),
    wellPanel(
      style = "border-color: lightgrey; border-width: 3px; border-radius: 10px;",
      fluidRow(
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
      )
    )
  )
)


