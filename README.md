
<img src="inst/img/logo_deployer.png" width="600px">

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

The RECON Deployer is an application of `nomad`, a R package for creating
portable R environments. You first need to install this package, which also depends on `provisionr`:

```r
remotes::install_github("mrc-ide/provisionr", upgrade = FALSE)
remotes::install_github("reconhub/nomad", upgrade = FALSE)
```

To create a deployer in a given directory named `deployer_[date]`, type:

```r
out_dir <- paste("deployer", gsub("-", "_", Sys.Date()), sep = "_")
nomad::build("reconhub/deployer", out_dir)
```



## Using a *deployer*

The *RECON deployer* is meant to be copied on a USB stick, although strictly
speaking it is medium-agnostic. To use the *deployer*, go to the folder where it
is stored, open the file called `README.html`, and follow the instructions
provided there.


