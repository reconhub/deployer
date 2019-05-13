
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


## Using a *deployer*

You can find versioned releases of deployers at 
https://github.com/reconhub/deployer/releases that detail how the deployer was
built and how to download/decompress it. If you want to build one from scratch,
see Building a new deployer

The *RECON deployer* is meant to be copied on a USB stick, although strictly
speaking it is medium-agnostic. To use the *deployer*, go to the folder where it
is stored, open the file called `README.html`, and follow the instructions
provided there.


## Building a new *deployer*

To build/generate a new *deployer*, you can use the R script [`generate_deployer.R`](./generate_deployer.R):

```
cd ..
Rscript reconhub--deployer/generate_deployer.R
```

### Details

The RECON Deployer is an application of `nomad`, a R package for creating
portable R environments. This script will do the following:

1. attempt to upgrade [provisioner](https://github.com/mrc-ide/provisionr) and 
   [nomad](https://github.com/reconhub/nomad)
2. generate the deployer
3. split the deployer into 4 compressed files with md5sums that can be [uploaded
   to github for release](https://github.com/reconhub/deployer/releases/new )

The files you end up with are:

| File name          | Description                                    |
|--------------------|------------------------------------------------|
|`<name>/`           | Source Directory for the deployer              |
|`<name>_md5sums.txt`| summary of the above files                     |
|`<name>_release.md` | release page to be placed on github            |
|                    |                                                |
|`<name>_base.tar`   | source packages, cheat sheets, and instructions|
|`<name>_extra.tar`  | binaries for R, git, Rtools, and RStudio       |
|`<name>_macosx.tar` | binary packages built for macos                |
|`<name>_windows.tar`| binary packages built for windows              |

> Note: These will likely be over 1GB each, so make sure you have a strong
> internet connection when uploading these to github.

Once downloaded from the github release page, the users can decompress the files
via R:

```r
untar('<name>_base.tar')
untar('<name>_extra.tar')
untar('<name>_macosx.tar')
untar('<name>_windows.tar')
```

### Generating the deployer manually

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


## Adding or updating packages 

If you need to add or update an R package, you can use the [`add_packages.R`](./add_packages.R)
script with the names of the CRAN packages to use.

```
Rscript add_packages.R officer kableExtra
```

If you have non-cran packages, then be sure to add the github repositories to
[`package_sources.txt`](./package_sources.txt).
