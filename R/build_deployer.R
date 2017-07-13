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

    message("\nSetting working directory...")
    setwd(dir)

    message("\nDownloading config files...")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/nomad.yml",
                         destfile = "nomad.yml")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/package_list.txt",
                         destfile = "package_list.txt")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/package_sources.txt",
                         destfile = "package_sources.txt")


    message("\nStarting nomad deployment...")
    nomad::pack(".")

    if (remove_config) {
        message("\nRemoving config files...")
        file.remove("nomad.yml", "package_list.txt", "package_sources.txt")
    }

    message("\nDownloading activation script...")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/activate_deployer.R",
                         destfile = "activate_deployer.R")
    message("\nDone!")

    message("\nDownloading documentation...")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/README_deployer.html",
                         destfile = "README_deployer.html")
    message("\nDone!")
}
