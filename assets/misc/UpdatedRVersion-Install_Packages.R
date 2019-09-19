#######
# just get the tools in place...
###
# devtools always first :-) 
install.packages("devtools")
# Bioconductor stuff
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install()

#######
# now move on to the installation of the most useful items...
###
# define packages we need to install
.cran_packages  <-  c("knitr", "phyloseqGraphTest", "shiny",
                    "miniUI", "caret", "pls", "e1071", "ggplot2", "randomForest",
                    "vegan", "plyr", "dplyr", "ggrepel", "nlme",
                    "reshape2", "devtools", "PMA","structSSI","ade4",
                    "igraph", "ggnetwork", "intergraph", "scales", 
                    # jake's additional packages
                    "vegan", "theseus", "data.table", "methods", "parallel", "R.utils", "ShortRead", "stringr", "rmarkdown", "testthat", "gridExtra"
                    )
.github_packages <- c("jfukuyama/phyloseqGraphTest", "adw96/breakaway", "bryandmartin/corncob")
.bioc_packages <- c("BiocStyle", "phyloseq", "dada2", "DESeq2", "genefilter", "impute", "DECIPHER", "phangorn")

###
# install packages which are not currently installed. 
(.inst <- .cran_packages %in% installed.packages())
if (any(!.inst)) {
  install.packages(.cran_packages[!.inst], repos = "http://cran.rstudio.com/")
}

(.inst <- .bioc_packages %in% installed.packages())
if (any(!.inst)) {
  BiocManager::install(.bioc_packages[!.inst])
}

(.inst <- .github_packages %in% installed.packages())
if (any(!.inst)) {
  devtools::install_github(.github_packages[!.inst])
}
