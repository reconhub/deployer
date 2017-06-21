#' Build a RECON deployer
#'
#' This function can be used to build a RECON deployer within a given directory.
#'
#' @author Thibaut Jombart
#'
#' @param dir The directory in which the RECON deployer is to be built.

build_deployer <- function(dir) {

    cat("\nDownloading config files...")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/nomad.yml", 
                         destfile = "nomad.yml")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/package_list.txt", 
                         destfile = "package_list.txt")
    utils::download.file("https://raw.githubusercontent.com/reconhub/deployer/master/package_sources.txt", 
                         destfile = "package_sources.txt")


    cat("\nStarting nomad deployment...")
    nomad::pack(".")

    
    cat("\nRemoving config files...")
    file.remove("nomad.yml", "package_list.txt", "package_sources.txt")

    cat("\nDone!")
}
