# *deployer*

The *RECON deployer* project focusses on distributing an R environment for outbreak response on a thumb drive. This environment should provide:

* the latest stable version of R for Windows and MacOSX

* the corresponding version of Rtools

* the latest stable version of Rstudio for Windows and MacOSX

* a large selection of relevant R packages hosted on CRAN

* all RECON packages hosted on github (sources)

* some other packages hosted on github, required by the above

* scripts to permit seemless installation of the local CRAN and github packages 

## Running it

Install nomad

```
devtools::install_github("reconhub/nomad", upgrade = FALSE)
```

In this directory, run

```
nomad::pack(".")
```
