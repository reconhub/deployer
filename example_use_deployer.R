## RECON deployer is used for installing R packages without internet

## This script should be run within the same directory as 'activate_deployer.R'.
## By default it should be the folder storing the rest of the RECON
## deployer. Start by running 'activate_deployer()' and then follow
## the examples for installing packages.


source("activate_deployer.R")
activate_deployer()



## Example 1: install a CRAN package as usual:
install.packages("outbreaks")


## Example 2: install a devel package - no difference:

install_devel("projections")
