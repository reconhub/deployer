
![recon_deployer_logo](img/logo_deployer.png)

<br>

Welcome to the *RECON deployer*!
===============================

The *RECON deployer* can be used to install R packages useful for outbreak
investigation without an internet connection. Follow the instructions below to
use the deployer. **Do not skip steps unless you know what you are doing!**


Thibaut Jombart, 22nd February 2018.


### Release notes

This is a beta version of the *RECON deployer*. If you have been given this USB
stick, this means you are officially one of our first testers. Further versions
will be made more user-friendly and simpler to use, based on the feedback of
this version. To report bugs, suggestions, or ask questions, please post an
issue on:

[https://github.com/reconhub/deployer/issues](https://github.com/reconhub/deployer/issues)





<br>

### Installing R 

#### Linux / MacOSX

On linux or MacOSX, it is assumed that a recent installation of R is available
with the toolchain for package development, but installation packages for
RStudio are provided (Debian-based systems only for linux).


#### Windows

Go to the `extra` folder, and install, in this order (version numbers may
change):

1. Git (`Git-2.13.1-64-bit.exe`)
2. Rtools (`Rtools34.exe`)
3. R (`R-3.4.3-win.exe`)
4. RStudio (`RStudio-1.1.423.exe`)



<br>

### Installing packages using the *deployer*

To use the *RECON deployer* needs to be activated before installing
packages. This is achieved by running the script `activate.R`, located in
the same folder as this help page. On Windows, the easiest way to do so is open
the file `activate_deployer.R` with RStudio, and then type in the R console:

```{r eval = FALSE}
source("activate.R")
```

Once activated, the *deployer* will be used as an offline source of R packages,
including a large (~1,000) selection of CRAN packages, plus all release branches
of RECON packages on github.


Once the script has been run, from the same R session, you can install CRAN
packages as usual (but without internet), for instance:

```{r eval = FALSE}
install.packages("outbreaks")
```

Non-CRAN packages are installed exactly the same way as CRAN packages; for
instance, to install the development version of `earlyR`, use:

```{r eval = FALSE}
install.packages("earlyR")
```

<br>
