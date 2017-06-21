#' Build a RECON deployer
#'
#' This function can be used to build a RECON deployer within a given directory.
#'
#' @author Thibaut Jombart
#'
#' @param dir The directory in which the RECON deployer is to be built. Defaults
#' to the current working directory.
#'
#' @param remove_config A logical indicating if config files used by 'nomad'
#' should be removed after installation; TRUE by default.
#'

build_deployer <- function(dir = getwd(), remove_config = TRUE) {
    if (!dir.exists(dir)) {
        cat("\nCreating directory:", dir)
        dir.create(dir)
    }
    
    dir <- normalizePath(dir)
    odir <- getwd()
    on.exit(setwd(odir))

    cat("\nSetting working directory...")
    setwd(dir)
    
    cat("\nDownloading config files...")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/nomad.yml", 
                         destfile = "nomad.yml")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/package_list.txt", 
                         destfile = "package_list.txt")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/package_sources.txt", 
                         destfile = "package_sources.txt")


    cat("\nStarting nomad deployment...")
    nomad::pack(".")

    if (remove_config) {
        cat("\nRemoving config files...")
        file.remove("nomad.yml", "package_list.txt", "package_sources.txt")
    }
    
    cat("\nAdding example package install file...")

    code_expl <- c(
        "## RECON deployer is used for installing R packages without internet",
        "## This small example illustrates how it works.",
        "\n",
        "## Set up RECON deployer as default package repository:", 
        paste0("options(repos = \"file://", dir, "\")"),
        "\n",
        "## Example 1: install a CRAN package as usual:",
        "install.packages(\"outbreaks\")",
        "\n",
        "## Example 2: install a devel package - no difference:",
        "install.packages(\"projections\")")

    cat(code_expl, sep = "\n", file = "example_use_deployer.R")
    
    cat("\nDone!")
}
