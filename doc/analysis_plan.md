
## Compare DE methods

### resistance to outliers

How analysis results will be affected by outliers, in terms of number of DEGs

### (practically) differentiate genes with extreme or moderate DEGs

Over-sensitive methods will fail to differentiate

### Run time

Dependence of run time on sample size


## Excluded methods

  - Bridge: Very slow, inconsistent output, highly disagree with other methods
  - BBSeq: not comply with newer R versions; bug in source code for paired test
  - BitSeq: only use RPKM as input
  - Cuffdiff: under-perform according to previous studies
  - derfinder: use DESeq2 for gene-level differential expression
  - DETERSeq: source code has bugs
  - RBM: essential the same as limma
  
