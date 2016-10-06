# RNA-seq 2G manual {.tabset}

***Zhe Zhang***

**2016-10-02**

<div style="padding:0 1cm;"><div style="border:black 1px solid; background:darkgrey; padding: .5cm .5cm"><font color="white">
**RNA-seq 2G** is a web portal with >20 statistical methods that perform two-group analysis of differential gene expression. It uses read count data from RNA-seq or similar data matrix as input and generates test statistics in consistent format as output. 
</font></div> </div>

&nbsp;
  
## Introduction {.tabset}

<div style="color:darkblue">
Two-group comparison of differential expression (DE) is the most common analysis of transcriptome data. For RNA-seq data, the comparison is usually performed on a gene-level matrix of read counts, with the read counts corresponding to the number of sequencing reads mapped to each gene in each RNA-seq sample. 
</div>
&nbsp;

### DE methods

<div style="padding:0 0.5cm;">
Statistical methods that have been applied to two-group DE of RNA-seq data are widely different in terms of their assumptions on data distribution, input/output format, performance, sensitivity, and user-friendliness, which are summarized in the table below:



<div style="color:darkblue; padding:0 0cm;">
**Table 1** Analysis methods for differential expression. 

Column description: 

  - **Name**: Method names to be showed on the web portal.
  - **Call**: The names of the re-implemented functions in the [DEGandMore](http://github.com/zhezhangsh/DEGandMore) package. 
  - **Default**: An arbitrarily selected popular DE methods.
  - **Speed**: How much time the DE method takes to finish. Typically, _fast_ methods take a few seconds, _medium_ methods take up to a minute, and _slow_ methods take a few minutes or more. Therefore, the waiting time will be long if any _slow_ methods are selected.
  - **Paired**: Whether the method supports paired test.
  - **Logged**: Wehther the original method is performed on transformed data in logged scale.
  - **Normalization**: Whether the method has its own internal normalization procedure. 
  - **Distribution**: Which data distribution the original method is based upon. 
  - **Test**: The statistical test used by the method. 
  - **Function**: The main function and package within which the method was originally implemented. 
</div>

<div style="padding:0 0cm;">

|Name                                                                                                                          |Call         |Default |Speed  |Paired |Logged |Normalization |Distribution          |Test                                        |Function                 |
|:-----------------------------------------------------------------------------------------------------------------------------|:------------|:-------|:------|:------|:------|:-------------|:---------------------|:-------------------------------------------|:------------------------|
|<a href="https://en.wikipedia.org/wiki/Student%27s_t-test" target="_blank">StudentsT</a>                                      |DeT          |Yes     |Fast   |Yes    |Yes    |No            |Normal                |Student's t test, equal variance            |TDist {stats}            |
|<a href="https://bioconductor.org/packages/release/bioc/html/limma.html" target="_blank">limma</a>                            |DeLimma      |Yes     |Fast   |Yes    |Yes    |No            |Normal                |Empirical Bayes moderation                  |ebayes {limma}           |
|<a href="https://bioconductor.org/packages/release/bioc/html/edgeR.html" target="_blank">edgeR</a>                            |DeEdgeR      |Yes     |Fast   |Yes    |No     |Yes           |Negative binomial     |Exact/Likelihood ratio                      |exactTest {edgeR}        |
|<a href="http://bioconductor.org/packages/release/bioc/html/DESeq.html" target="_blank">DESeq2</a>                            |DeDeSeq      |Yes     |Fast   |Yes    |No     |Yes           |Negative binomial     |Generalized linear model                    |DESeq {DESeq2}           |
|<a href="https://bioconductor.org/packages/release/bioc/html/ABSSeq.html" target="_blank">ABSSeq</a>                          |DeAbsSeq     |No      |Fast   |Yes    |No     |Yes           |Negative binomial     |Sum of counts                               |callDEs {ABSSeq}         |
|<a href="https://www.bioconductor.org/packages/3.3/bioc/html/BGmix.html" target="_blank">BGmix</a>                            |DeBGmix      |No      |Fast   |Yes    |Yes    |No            |Normal                |Bayesian mixture model                      |BGmix {BGmix}            |
|<a href="https://cran.r-project.org/web/packages/PoissonSeq/index.html" target="_blank">PoissonSeq</a>                        |DePoissonSeq |No      |Fast   |Yes    |No     |Yes           |Poisson log-linear    |Poisson goodness-of-fit                     |PS.Main {PoissonSeq}     |
|<a href="http://bioconductor.org/packages/3.3/bioc/html/RBM.html" target="_blank">RBM</a>                                     |DeRBM        |No      |Fast   |No     |Yes    |No            |Normal                |Empirical Bayes & resampling                |RBM_T {RBM}              |
|<a href="http://www.ncbi.nlm.nih.gov/pubmed/24485249" target="_blank">voom</a>                                                |DeVoomLimma  |No      |Fast   |Yes    |No     |Yes           |Log-normal            |Empirical Bayes moderation                  |voom {limma}             |
|<a href="https://en.wikipedia.org/wiki/Welch%27s_t-test" target="_blank">WelchsT</a>                                          |DeWelch      |No      |Fast   |Yes    |Yes    |No            |Normal                |Welch's t test, unequal variance            |TDist {stats}            |
|<a href="http://bioconductor.org/packages/release/bioc/html/DEGseq.html" target="_blank">DEGseq</a>                           |DeDegSeq     |No      |Medium |No     |No     |No            |Binomial/Poisson      |Likelihood Ratio Test                       |DEGexp {DEGseq}          |
|<a href="http://bioconductor.org/packages/release/bioc/html/EBSeq.html" target="_blank">EBSeq</a>                             |DeEbSeq      |No      |Medium |No     |No     |Yes           |Negative Binomial     |Empirical Bayesian                          |EBTest {EBSeq}           |
|<a href="https://bioconductor.org/packages/3.3/bioc/html/NOISeq.html" target="_blank">NOISeq</a>                              |DeNoiSeq     |No      |Medium |No     |No     |Yes           |Nonparametric         |Empirical Bayes                             |noiseqbio {NOISeq}       |
|<a href="https://www.bioconductor.org/packages/release/bioc/html/plgem.html" target="_blank">PLGEM</a>                        |DePlgem      |No      |Medium |Yes    |No     |No            |Normal                |Power Law Global Error Model                |run.plgem {plgem}        |
|<a href="https://bioconductor.org/packages/release/bioc/html/RankProd.html" target="_blank">RankProd</a>                      |DeRankP      |No      |Medium |Yes    |Yes    |No            |Nonparametric         |Rank product                                |RP {RankProd}            |
|<a href="http://statweb.stanford.edu/~tibs/SAM/" target="_blank">SAM</a>                                                      |DeSam        |No      |Medium |Yes    |Yes    |No            |Normal                |Alternative t test with permutation         |samr {samr}              |
|<a href="http://statweb.stanford.edu/~tibs/SAM/" target="_blank">SAMSeq</a>                                                   |DeSamSeq     |No      |Medium |Yes    |No     |No            |Nonparametric         |Wilcoxon with resampling                    |SAMseq {samr}            |
|<a href="http://bioconductor.org/packages/3.3/bioc/html/sSeq.html" target="_blank">sSeq</a>                                   |DeSSeq       |No      |Medium |No     |No     |No            |Negative Binomial     |Shrinkage Approach of Dispersion Estimation |nbTestSH {sSeq}          |
|<a href="https://en.wikipedia.org/wiki/Wilcoxon_signed-rank_test" target="_blank">Wilcoxon</a>                                |DeWilcoxon   |No      |Medium |Yes    |Yes    |No            |Nonparametric         |Wilcoxon signed-rank test                   |wilcox.test {stats}      |
|<a href="http://bioconductor.org/packages/release/bioc/html/baySeq.html" target="_blank">baySeq</a>                           |DeBaySeq     |No      |Slow   |Yes    |No     |No            |Negative binomial     |Empirical Bayesian                          |getLikelihoods {baySeq}  |
|<a href="http://bioconductor.org/packages/3.3/bioc/html/bridge.html" target="_blank">bridge</a>                               |DeBridge     |No      |Slow   |No     |Yes    |No            |T/Gaussian            |Bayesian hierarchical model                 |bridge.2samples {bridge} |
|<a href="http://bioconductor.org/packages/release/bioc/html/LMGene.html" target="_blank">LMGene</a>                           |DeLMGene     |No      |Slow   |Yes    |No     |No            |Normal                |Linear model & glog transformation          |genediff {LMGene}        |
|<a href="https://bioconductor.org/packages/release/bioc/html/ALDEx2.html" target="_blank">ALDEx2</a>                          |DeAldex2     |No      |Slower |Yes    |No     |Yes           |Dirichlet             |Welch's t/Wilcoxon/Kruskal Wallace          |aldex {ALDEx2}           |
|<a href="https://www.bioconductor.org/packages/3.3/bioc/html/BADER.html" target="_blank">BADER</a>                            |DeBader      |No      |Slower |No     |No     |Yes           |Overdispersed poisson |Bayesian                                    |BADER {BADER}            |
|<a href="http://bioinformatics.oxfordjournals.org/content/early/2015/04/21/bioinformatics.btv209" target="_blank">edgeRun</a> |DeEdgeRun    |No      |Slower |Yes    |No     |Yes           |Negative binomial     |Exact unconditional                         |UCexactTest {edgeRun}    |
|<a href="http://bioconductor.org/packages/release/bioc/html/tweeDEseq.html" target="_blank">tweeDEseq</a>                     |DeTweeDeSeq  |No      |Slower |No     |No     |Yes           |Poisson-Tweedie       |Poisson-like                                |tweeDE {tweeDEseq}       |
</div>

</div>

### Test statistics

<div style="padding:0 0.5cm;">
All DE methods available through **RNAseq 2G** report a 6-column table of test statistics. All tables from the same analysis will have the same size and the same number and order of row and column names. The rows are the genes of read count matrix, after filtering for missing values and low read count.

<div style="color:darkblue; padding:0 0cm;">
**Table 2** Example of analysis output from all DE methods, a 6-column table:

Column description: 

  - **Mean_Control** and **Mean_Patient** The group means of normalized read counts, using the internal normalization of the DE method or user-specified normalization if the method doesn't have one. If the DE method uses log-transformed data, the final values in these columns will be un-logged.
  - **Patient-Control**: The different between the first 2 columns. 
  - **LogFC**: The log2-ratio of group means, which is often refered to as _fold change_. For example, when the average read counts of the two groups is 1:4, the log2-ratio equals to 2.0; and when the ratio is 8:1, the log2-ratio will be -3.0. If a DE method has no its own algorithms to calculate log2-ratios, the values will be calculated based on normalized data. Missing values will be replaced with 0. 
  - **Pvalue**: The statistical significance of group difference. This is the column that differs all DE methods as each method has its own assumption about data distribution and choice of statistical test. Missing values in the original result will be replaced by 1.0 in the final table. **RNA-seq 2G** provides online visualization to compare p values from different DE methods side-by-side. 
  - **FDR**: False discovery rate calculated from the p value using the _Benjamini-Hochberg_ method. Although some DE methods also calculate FDRs or other adjusted p values using their own algorithms, they will not be used in this table. Therefore, the values in this column is solely based on the ***Pvalue*** column and calculated the same way for all DE methods. 
</div>

<div style="padding:0 1cm"> 

|         | Mean_Control | Mean_Patient | Control-Patient |  LogFC  | Pvalue  |  FDR  |
|:--------|:------------:|:------------:|:---------------:|:-------:|:-------:|:-----:|
|A1BG     |    2.4379    |    4.0794    |     1.6415      | 0.5684  | 0.44000 | 0.610 |
|A1BG-AS1 |    7.8024    |   13.5533    |     5.7509      | 0.8885  | 0.34000 | 0.520 |
|A1CF     |    0.7970    |    1.7488    |     0.9518      | 1.3458  | 0.35000 | 0.540 |
|A2M      |   14.3158    |    3.0886    |    -11.2272     | -2.1986 | 0.08400 | 0.230 |
|A2M-AS1  |   24.6289    |    6.3006    |    -18.3283     | -2.1011 | 0.08500 | 0.230 |
|A4GALT   |    0.2714    |    5.0005    |     4.7291      | 2.3824  | 0.23000 | 0.410 |
|AAAS     |   66.9266    |   34.9312    |    -31.9954     | -0.9293 | 0.00650 | 0.076 |
|AACS     |   20.0464    |   11.2508    |     -8.7957     | -0.8621 | 0.03600 | 0.150 |
|AAED1    |   100.2450   |   110.5209   |     10.2759     | 0.0725  | 0.85000 | 0.910 |
|AAGAB    |   83.6005    |   152.3225   |     68.7220     | 0.8871  | 0.00780 | 0.082 |
|AAK1     |   947.7917   |   173.8182   |    -773.9735    | -2.3011 | 0.01400 | 0.100 |
|AAMDC    |    5.5618    |    1.0051    |     -4.5567     | -2.6119 | 0.01300 | 0.098 |
|AAMP     |   46.4962    |   32.5321    |    -13.9641     | -0.5125 | 0.05000 | 0.170 |
|AANAT    |    2.4125    |    9.3400    |     6.9275      | 1.6817  | 0.10000 | 0.250 |
|AAR2     |   17.4167    |   62.8776    |     45.4609     | 1.8744  | 0.00085 | 0.043 |
|AARS     |   49.9801    |   59.8619    |     9.8819      | 0.2605  | 0.57000 | 0.720 |
</div>

</div>

## Prepare inputs {.tabset}

<div style="color:darkblue; padding:0 0.5cm;">
For RNA-seq data the raw sequencing reads need to be aligned to the reference genome and transcriptome using any alignment program. Next, the aligned reads should be assigned to annotated genes or transcripts to generate a read count matrix. RNA-seq 2G accepts other types of data, such as those generated by the proteomics and Nanostring technologies, as long as the raw data was processed similarly to generate a integer matrix. 
</div>
&nbsp;

### Read count matrix

<div style="padding:0 0.5cm;">
Using gene-level data from RNA-seq as an example, the read count matrix should have rows corresponding to unique genes and columns corresponding to unique samples, and each cell should be the number of sequencing reads of a sample mapped to a gene. Missing values are allowed, and will be dealt with before the analysis starts. **The row and column names of the matrix must be unique gene and sample IDs respectively.** The type of gene IDs (official symbols, RefSeq, etc.) doesn't matter. **RNA-seq 2G** accepts the read count matrix in different types of files and examples can be downloaded [here](https://github.com/zhezhangsh/awsomics/raw/master/rnaseq_2g/data/count_example.zip).

  - **R file**(***.rds, .rda, or .rdata***) that saves the read count matrix as a matrix or data.frame object.
  - **Tab-delimited text file**(***.txt***) that has the gene IDs in the first column and sample IDs in the first row. 
  - **Comma-delimited text file**(***.csv***) that has the gene IDs in the first column and sample IDs in the first row. 
  - **Excel file**(***.xls or .xlsx***) that has the matrix in the first worksheet and the gene and sample IDs in the first column and row. 
  - **HTML file**(***.htm or .html***) that has the matrix as the first HTML table within the ***table*** tag.
</div>

### Sample grouping

<div style="padding:0 0.5cm;">
Sample IDs should be grouped into two groups to be compared. The sample IDs must match the column names of the read count matrix. The default names of the groups  are ***Control*** and ***Case*** if the they are not explicitly named. **For paired test**, both groups must have the same number of samples and the paired samples must be in the same order.** **RNA-seq 2G** allows users to type in the group names and sample IDs directly or upload a formmated file. Examples of acceptable file formats can be downloaded [here](https://github.com/zhezhangsh/awsomics/raw/master/rnaseq_2g/data/group_example.zip).

  - **R file**(***.rds, .rda, or .rdata***) that is a list of two named character vectors of sample IDs.
  - **Tab-delimited text file**(***.txt***) that includes two lines, both started with group name and followed by sample IDs.
  - **Comma-delimited text file**(***.csv***) that includes two lines, both started with group name and followed by sample IDs.
  - **Excel file**(***.xls or .xlsx***) that includes two rows, both started with group name and followed by sample IDs.
</div>

### Other parameters

<div style="padding:0 0.5cm;">
Users also need to specify a few parameters to run the DE analysis:

 - **Paired**: Whether the comparison is paired. Only applicable to DE methods supporting paired test. The compared groups must have the same number of samples for paired test and the paired samples need to be organized in the same order. 
 - **Missing value**: What to do with missing values. The options are replacing missing values with 0 and removing the genes including any missing values. The imputation option is currently not available, so users need to do it themselves if they want their data imputed. Indeed, it's highly encouraged that users handle the missing values with their favorite strategy beforehand. 
 - **Minimal count**: Genes with total read counts from all samples less than this number will not be included in the result.
 - **Normalization**: How to normalize the read count matrix if the DE method has no its own methods. 

    - **Normalization of read count**: How to normalize read count data. The options are "DESeq", "TMM", "RLE", "QQ", "UpperQuantile", "Median", and "TotalCount".
    
        - **DESeq**: the default normalization method provided the **DESeq2** package.
        - **TMM**: the "trimmed mean of M-values" method provided by the **EdgeR** package.
        - **RLE**: the "relative log expression" method provided by the **EdgeR** package.
        - **QQ**: the quantile-quantile normalization to make all samples have the exactly same distribution.
        - **UpperQuantile**: rescale data so all the samples have the same upper quantile.
        - **Median**: rescale data so all the samples have the same median.
        - **TotalCount**: rescale data so all the samples have the same total number of read counts.
        
    - **Normalization of logged data**: How to normalize data after it's log-transformed. The options are "Loess", "VST", "Rlog", "QQ", "UpperQuantile", and "Median".
    
        - **Loess**: fit pairs of samples to local regression.
        - **VST**: the "variance stabilizing transformation" method provided the **DESeq2** package.
        - **Rlog**: the "regularized log transformation" method provided the **DESeq2** package.
        - **QQ**: the quantile-quantile normalization to make all samples have the exactly same distribution.
        - **UpperQuantile**: rescale data so all the samples have the same median.
        - **Median**: rescale data so all the samples have the same median.
</div>

## Run analysis online {.tabset}

<div style="color:darkblue; padding:0 0.5cm;">
**RNAseq 2G** provides a user-friendly web portal to run a DE analysis using any of the available methods. Each analysis will be assigned a random ID and its results can be re-visited by specifying the ID. To set an analysis go to http://rnaseq2g.awsomics.org and finish 3 simple steps described below within the on the **Analysis** page. 
</div>
&nbsp;

### Step 1

<div style="padding:0 0.5cm;">
<div align='center'>
![](figure/analysis_step1.png)
</div>
<div style="color:darkblue; padding:0 0cm">
**Figure 1A.** Set up online DE analysis, Step 1.

  - **A:** upload a local file of read count matrix in one of the acceptable formats.
  - **B:** click file extension to download an example file in acceptable format. 
  - **C:** once a read count matrix is successfully loaded, the first a few rows will be showed for visual confirmation.
</div>
</div>

### Step 2

<div style="padding:0 0.5cm;">
<div align='center'>
![](figure/analysis_step2.png)
</div>
<div style="color:darkblue; padding:0 0cm">
**Figure 1B.** Set up online DE analysis, Step 2.

  - **A:** upload a local file of sample grouping in an acceptable formats; the group names and sample ID will show up in boxes on the right.
  - **B:** click file extension to download an example file in acceptable format.
  - **C:** group names; can be directly typed in or automatically added through loaded file.
  - **D:** sample IDs; can be directly typed in (separated by commas) or automatically added through loaded file; for paired test, both groups should have the same number of samples and paired samples should be in the same order. 
  - **E:** paired or unpaired test; will be ignored if the DE method doesn't support paired test.
  - **F:** replace missing values with 0 or remove the genes including any missing value.
  - **G:** methods to normalize original read count data and log-transformed data; ignored if the DE method has its own normalization.
  - **H:** genes with total number of reads less than this number will not be included in the results.
</div>
</div>

### Step 3

<div style="padding:0 0.5cm;">
<div align='center'>
![](figure/analysis_step3.png)
</div>
<div style="color:darkblue; padding:0 0cm">
**Figure 1C.** Set up online DE analysis, Step 3.

  - **A:** pick the DE methods to run.
  - **B:** quickly pick a subset of methods to run.
  - **C:** click to show detailed description of all DE methods. 
</div>
</div>

## Run analysis offline {.tabset}

<div style="color:darkblue; padding:0 0.5cm;">
An alternative to use **RNA-seq 2G** is to directly call the ***DeRNAseq {DEGandMore}*** function within R. This option is more suitable for DE analysis runs using any of the slow methods (see **Table 1**). When any slow DE methods are selected, the online waiting might be too long and users should run the DE analysis offline, but can later upload their results to **RNAseq 2G** for visualization. Running the offline analysis  takes some basic R skills and a few simple steps.
</div>
&nbsp;

### Install packages

<div style="padding:0 0.5cm;">
Open RStudio or R console, **make sure the base version of R is 3.2 or higher and have the _devtools_ package installed**, using the code below to find out.


```r
version;
if(!require('devtools')) install.packages('devtools'); 
```

Install all required R packages from CRAN, Bioconductor, and GitHub and test if they can be loaded properly using the code below. Depending on how many packages need to be installed, this process might take a while. If everything goes well, you will get a message at the end of screen messages, saying _"Congratulations! All required packages have been installed and loaded."_
  

```r
require(devtools);
source_url("https://raw.githubusercontent.com/zhezhangsh/DEGandMore/master/installer.r"); 
```
</div>

### Perform analysis

<div style="padding:0 0.5cm;">
Run DE analysis using the code below based on the **DEGandMore::DeRNAseq** function. 


```r
require(RoCA);
require(DEGandMore); 

# Import read count matrix and sample grouping from files; see above for acceptable file formats
read.count   <- ImportTable('my_read_count_file');
sample.group <- ImportList('my_sample_group_file');

# Set up parameters
pr <- FALSE;   # change to TRUE for paired test
md <- 0;       # change to 1-4 for other method groups or specific method names
mc <- 6;       # change to another non-negative integer for a different cutoff
nc <- 1;       # change to 2 or higher if the system supports parallel computing
n1 <- 'DESeq'; # change to "TMM", "RLE", "QQ", "UpperQuantile", "Median", or "TotalCount" to use other methods
n2 <- 'Loess'; # change to "VST", "Rlog", "QQ", "UpperQuantile", or "Median" to use other methods

####################################################################################################
# Run DE analysis
my.analysis.result <- DeRNAseq(ct = read.count, grps = sample.group, mthds = md, paired = pr,
                               min.count = mc, num.cluster = nc, just.stat = TRUE, 
                               norm.count = n1, norm.logged = n2, force.norm = TRUE);
# note that the parameters 'just.stat' and 'force.norm' should always be TRUE for RNAseq 2G
####################################################################################################

# save results to file
saveRDS(my.analysis.result, 'my_analysis_result.rds');
# the 'my_analysis_result.rds' file can now be uploaded to the RNAseq 2G web portal for visualizaiton
```

Alternatively, simply run DE analysis using just 2 specific methods and default parameters.


```r
my.analysis.result <- DeRNAseq(read.count, sample.group, c('DeEdgeR', 'DeDeSeq'), force.norm = TRUE);
```
</div>

### List methods

<div style="padding:0 0.5cm;">
Available DE methods and method groups can be found using the code below.




```r
DeRNAseqMethods(group=0); # Default methods
```

```
## [1] "DeT"     "DeLimma" "DeEdgeR" "DeDeSeq"
```

```r
DeRNAseqMethods(group=1); # Fast methods
```

```
##  [1] "DeT"          "DeLimma"      "DeEdgeR"      "DeDeSeq"      "DeAbsSeq"     "DeBGmix"      "DePoissonSeq"
##  [8] "DeRBM"        "DeVoomLimma"  "DeWelch"
```

```r
DeRNAseqMethods(group=2); # Fast+medium methods
```

```
##  [1] "DeT"          "DeLimma"      "DeEdgeR"      "DeDeSeq"      "DeAbsSeq"     "DeBGmix"      "DePoissonSeq"
##  [8] "DeRBM"        "DeVoomLimma"  "DeWelch"      "DeDegSeq"     "DeEbSeq"      "DeNoiSeq"     "DePlgem"     
## [15] "DeRankP"      "DeSam"        "DeSamSeq"     "DeSSeq"       "DeWilcoxon"
```

```r
DeRNAseqMethods(group=3); # Fast+medium+slow methods
```

```
##  [1] "DeT"          "DeLimma"      "DeEdgeR"      "DeDeSeq"      "DeAbsSeq"     "DeBGmix"      "DePoissonSeq"
##  [8] "DeRBM"        "DeVoomLimma"  "DeWelch"      "DeDegSeq"     "DeEbSeq"      "DeNoiSeq"     "DePlgem"     
## [15] "DeRankP"      "DeSam"        "DeSamSeq"     "DeSSeq"       "DeWilcoxon"   "DeBaySeq"     "DeBridge"    
## [22] "DeLMGene"
```

```r
DeRNAseqMethods(group=4); # All methods
```

```
##  [1] "DeT"          "DeLimma"      "DeEdgeR"      "DeDeSeq"      "DeAbsSeq"     "DeBGmix"      "DePoissonSeq"
##  [8] "DeRBM"        "DeVoomLimma"  "DeWelch"      "DeDegSeq"     "DeEbSeq"      "DeNoiSeq"     "DePlgem"     
## [15] "DeRankP"      "DeSam"        "DeSamSeq"     "DeSSeq"       "DeWilcoxon"   "DeBaySeq"     "DeBridge"    
## [22] "DeLMGene"     "DeAldex2"     "DeBader"      "DeEdgeRun"    "DeTweeDeSeq"
```
</div>

## Browse results {.tabset}

<div style="color:red; padding:0 0.5cm;">
***TO BE FINISHED***
</div>
&nbsp;

<div style="color:darkblue; padding:0 0.5cm;">
Results of DE analysis can be visualized and compared online via **RNAseq 2G**.
</div>
&nbsp;

<div align='center'>
![](figure/result_upload.png)
</div>
<div style="color:darkblue; padding:0 0cm">

</div>

<div align='center'>
![](figure/result_table.png)
</div>
<div style="color:darkblue; padding:0 0cm">

</div>

<div align='center'>
![](figure/result_plot.png)
</div>
<div style="color:darkblue; padding:0 0cm">

</div>

<div align='center'>
![](figure/compare_both.png)
</div>
<div style="color:darkblue; padding:0 0cm">

</div>

<div align='center'>
![](figure/compare_rank.png)
</div>
<div style="color:darkblue; padding:0 0cm">

</div>

<div align='center'>
![](figure/compare_both.png)
</div>
<div style="color:darkblue; padding:0 0cm">

</div>


---
END OF DOCUMENT

