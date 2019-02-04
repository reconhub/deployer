#' Update a package in a deployer from the source code
#'
#' @param pkg the path to a package source
#' @param repo path to a drat repo. Defaults to the current  repo 
#' @param internet a future parameter to update packages from internet if it is
#'   available.
#' @examples
#'
#' deploy_package("../linelist") # update the linelist package, assuming its
#'   source lives one directory upstream of this deployer
deploy_package <- function(pkg = NULL, repo = ".", internet = FALSE) {
  if (is.null(pkg)) {
    msg <- paste(
      "Please supply a path to a package source"
    )
    stop(msg)
  }
  stopifnot(file.exists(pkg))
  stopifnot(file.exists(file.path(repo, 'src', 'contrib')))
  
  vers <- read.dcf(file.path(pkg, "DESCRIPTION"))[, "Version"]
  message("Building source package ...")
  src <- devtools::build(pkg, path = repo, binary = FALSE)
  

  message(sprintf("Adding package and to %s", repo))
  drat::insertPackage(src, action = "archive", repodir = repo) 
  
  unlink(src)
  return(NULL)
}
