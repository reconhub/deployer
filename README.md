
<img src="http://github.com/reconhub/deployer/raw/master/img/logo-deployer.png">

<br>


The *RECON deployer* project focusses on distributing an R environment for outbreak response on a thumb drive. This environment should provide:

* the latest stable version of R for Windows and MacOSX

* the corresponding version of Rtools

* the latest stable version of Rstudio for Windows and MacOSX

* a large selection of relevant R packages hosted on CRAN

* all RECON packages hosted on github (sources)

* some other packages hosted on github, required by the above

* scripts to permit seemless installation of the local CRAN and github packages 



## Building a new *deployer*

To build a new deployer, you first need to install `nomad`:

```
devtools::install_github("reconhub/nomad", upgrade = FALSE)
```

Then execute the following script in a directory where you want to install the
RECON Deployer:

```
## source install script
source("https://raw.githubusercontent.com/reconhub/deployer/master/R/build_deployer.R")

## create temporary directory
target_dir <- tempdir()
target_dir


## run install script
build_deployer(target_dir)

## check content of new directory
dir(target_dir)

```



## Using a *deployer*

The *RECON deployer* is meant to be copied on a USB stick, although strictly
speaking it is medium-agnostic. To use the *deployer*, go to the folder where it
is stored, open the file called `README.html`, and follow the instructions
provided there.


