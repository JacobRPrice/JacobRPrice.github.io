---
layout: post   
title: Installing multiple parallel versions of R on Mac and getting back up and running quickly by simplifying package installation
author: Jake Price   
---

## caveat emptor    
I'm not a computer scientist nor did I sleep at a Holiday Inn last night.    

Given all of the varieties of mac OS X, and the innumerable ways of installing and maintaining R I can't guarantee that the outline below will work for your precise situation. **Please make sure to backup your computer or use TimeMachine prior to giving this a try!**    

## Motivation & Setup    
A large portion of my current responsibilities focus on the development and deployment of a new R package. Through this effort I've encountered a couple of versioning-related challenges including:   
* many of the packages I had been using are out of date (who has time to keep them updated?)   
* some of the new packages I want to leverage within my own project require a more recent R version  
* (ideally) a developer should keep in mind that thier users may not have the latest and greatest installation, and may be hesitant to change things on thier local install just to try out a piece of software
* installing a new (or old) version of R via binary (*.pkg) runs the significant risk of wiping out your current r library
* and lastly, (at face value) it's not possible/easy to switch between versions of R even if you manage to get two or more of them installed. 

For these reasons and more, I personally tend to resist updating both R versions and package versions. My thinking is that it works now, why take the risk of messing it up and giving myself the headache? 

Well, my current role doesn't give me that luxury and so I had to find a way to let me properly develop my project while meeting a number of requirements:    
1) Works well with RStudio   
2) installing multiple versions of R (e.g. v3.4, v3.5, v3.6)   
3) switch easily between the different versions   
4) keep each version's package libraries separate and independent from one another   
5) have, or enable, an easy/quick way to install my "most vital" packages for the newer versions. 

Sounds reasonable right? It also sounds like there should be a dummies-guide for doing this right? *Not the case*; there were a ton of resources which takes you halfway through the process, but not all the way. Since I went through the hour or two figuring out how to do it, let me save you the effort... 

## RStudio    
Go ahead and open up an instance of `Terminal` and see what: `which r` returns. That is the location/path/alias of the binary that will be executed when you open up RStudio. When you install a "new" (can be older/depreciated) version of R, part of the install process is updating that symbolic link. As far as RStudio is concerned, there are no concerns, we just have to make sure it's updated. 

## Installation   
But how do we go through the process of installing different versions of R to begin with? If we were to just blindly use the binary installer (*.pkg) version available through CRAN [here](https://cran.r-project.org/bin/macosx/), the installer will remove the current version of the r framework (including your package libraries). If that happens it ruins the whole point of going through this exercise. 

Instead, what we can do *prior* to installing the new version of R is trick OSX into forgetting that R is already installed on your system by using pkgutil. Executing the following in `Terminal` will make your system ignore the already installed R versions, leaving the original framework in place while installation of the new version is carried out.   

```
sudo pkgutil --forget org.r-project.R.el-capitan.fw.pkg \
             --forget org.r-project.x86_64.tcltk.x11 \
             --forget org.r-project.x86_64.texinfo \
             --forget org.r-project.R.el-capitan.GUI.pkg
```

Once you carry out your `pkgutil` trickery, you can go ahead and download the *.pkg of the R version you want to install and install it like you normally would. If you momentarily open RStudio, you should see that it prints out the new version!  

*Aside:* if you want to know why this works, check out the "Uninstalling under MacOS" and "Multiple versions" headings of the [R Installation and Administration](https://cran.rstudio.org/doc/manuals/R-admin.html#Uninstalling-under-macOS) document or the [RSwitch - Guide page](https://web.archive.org/web/20190919163832/https://rud.is/rswitch/guide/).     

## Parallel versions and their location   
But wait, where'd the old version go? If you carried out your installation with the default values, take a look in this directory:    

>/Library/Frameworks/R.framework/Versions/

(You can open up a finder window, press `CMD`+`shift`+`g` and search for it directly instead of manually navigating)

You should see one directory for each of the X.Y versions of R you've installed, along with a "Current" directory which is just a symlink to the most recently installed version. "Current" is what your system (and RStudio) is seeing by default. 

## Switching between versions   
Alright, that's all well and good, but now we have to figure out how to switch between the different versions. We have some options!   
* [rswitch](https://mac.r-project.org/) available through the R for Mac OS X Developer's page - A very simple GUI that will work with almost any version of R/OSX. - This is the option I went for.   
* [RSwitch](https://rud.is/rswitch/guide/index.html) a nicer looking GUI that requires more recent versions of OSX.    
* You can also use `ln -s` via Terminal to reassign the symlink manually.    

## Package Installation    
We have our different versions installed, and we can switch between them, but the "new"/additional versions don't have any packages installed. As we know fresh installs can be super boring as we wait for them to be carried out. To make my life easier, I adapted a portion of a script from [Callahan et. al. (2016)](https://f1000research.com/articles/5-1492/v2) to streamline the process. The concept is to define chr vectors containing the names of your most used packages and then test to see if they are currently installed, if not, install them. The user can select/highlight and source the entire script in RStudio and walk away while the work proceeds. I do want to note that depending upon your R version and the packages you want to install you may have to run the script twice to catch any weird dependency conflicts that might not play nice. If you're clever, you can adapt the script to also auto-update packages as well. You can download the .R script [HERE]({{ site.url }}/assets/misc/UpdatedRVersion-Install_Packages.R), or you can take a gander at the code below...    

{% highlight r linenos %}
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
{% endhighlight %}  

