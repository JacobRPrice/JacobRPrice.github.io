---
layout: post
title: Moving phyloseq data to vegan and back again
---

## Prelude
[phyloseq](https://github.com/joey711/phyloseq) is an incredibly useful R package for the organization, analysis, and graphical visualization of sequencing data. Much of it's ordination-related utility is derived from (or wraps) functions available from the [vegan](https://cran.r-project.org/web/packages/vegan/index.html) package. Both of these packages have their own strengths and weaknesses. Unfortunately phyloseq does not pull in *all* of the funcitonality from vegan, including clustering, the whole gambit of standardization and normalization methods, and significance testing (and who can blame them, there are a ton of features!). 

At the same time, one should recognize that the plotting features within vegan use the base plot() structure within R. It can be challenging to make a pretty, easily interpretable, plots using vegan, which is especially true as data objects get larger and larger, practically a trueism in today's age of massive sequencing projects with hundreds of samples and thousands (or tens of thousands) of species/OTUs. phyloseq harnesses ggplot2 to easily make and modify aethetically pleasing plots. 

While I do most of my work within phyloseq, I've found it very useful to port data objects between the two packages if I want to carry out a specific analysis or take advantage of certain features. Here are some quick and simple functions/approaches that you can use to move data from phyloseq-compatible objects to vegan-compatable objects and back again. 

## phyloseq to vegan   
Analyzing phyloseq objects in vegan requires you to convert them into simpler data structures (dataframes, matricies, etc). Analysis isn't the only use; you could use vegan to carry out standardization/scaling on metadata (sample_data()) or to carry out some form of tranformation on OTU tables (otu_table()). 

{% highlight r linenos %}
# convert the sample_data() within a phyloseq object to a vegan compatible data object
pssd2veg <- function(physeq) {
  sd <- sample_data(physeq)
  return(as(sd,"data.frame"))
}

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
How do you get your altered data back into your phyloseq object (or create a new phyloseq object)? Easy! 

{% highlight r linenos %}
# move an OTU table from vegan to phyloseq  
otu_table(PhyloseqObject) <- otu_table(veganOTUobject, taxa_are_rows=TRUE)  
# move sample data from vegan to phyloseq
sample_data(PhyloseqObject) <- as.data.frame(veganSampleDataObject)
{% endhighlight %}  
