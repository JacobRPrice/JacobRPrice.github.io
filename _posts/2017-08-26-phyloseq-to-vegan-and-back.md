---
layout: post
title: Moving phyloseq data to vegan and back again
---

## Prelude
[phyloseq](https://github.com/joey711/phyloseq) is an increadibly useful R package for the organization, analysis, and graphical visualization of sequencing data. Much of it's ordination-related functionality pulls from functions available from the [vegan](https://cran.r-project.org/web/packages/vegan/index.html) package. Both of these packages hae their own strengths and weaknesses. Unfortunately phyloseq does not pull in *all* of the funcitonality from vegan, including clustering, the whole gambit of standardization and normalization methods, and significance testing (and who can blame them, there are a ton of features!). At the same time, one should recognize that the plotting features within vegan use the base plot() structure within R. It can be challenging to make a pretty, easily interpretable, plots using vegan, which is especially true as data objects get larger and larger, practically a trueism in today's age of massive sequencing projects with hundreds of samples and thousands (or tens of thousands) of species/OTUs. phyloseq harnesses ggplot2 to easily make and modify aethetically pleasing plots. 

While I do most of my work within phyloseq, I've found it very useful to port data objects between the two packages if I want to carry out a specific analysis or take advantage of certain features. Here are two quick and simple functions that you can use to move data from phyloseq-compatable objects to vegan-compatable objects and back again. 

## phyloseq to vegan   

{% highlight r linenos %}  
# convert the sample_data() within a phyloseq object to a vegan compatible data object
pssd2veg <- function(physeq) {
  sd <- sample_data(physeq)
  return(as(sd,"data.frame"))
}
{% endhighlight %}  


{% highlight r linenos %}  
# convert the otu_table() within a phyloseq object to a vegan compatible data object
psotu2veg <- function(physeq) {
  OTU <- otu_table(physeq)
  if (taxa_are_rows(OTU)) {
    OTU <- t(OTU)
  }
  return(as(OTU, "matrix"))
}
{% endhighlight %}  

## vegan to phyloseq