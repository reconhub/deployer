#' Update a package in a deployer from the source code
#'
#' @param pkg the path to a package source
#' @param repo path to a drat repo. Defaults to both the current and 'drat' repo 
#' @param internet a future parameter to update packages from internet if it is
#'   available.
#' @examples
#'
#' deploy_package("../linelist") # update the linelist package, assuming its
#'   source lives one directory upstream of this deployer
deploy_package <- function(pkg = NULL, repo = c(here::here(), here::here("drat")), internet = FALSE) {
  if (is.null(pkg)) {
    msg <- paste(
      "Please supply a path to a package source"
    )
    stop(msg)
  }
  stopifnot(file.exists(pkg))
  
  vers <- read.dcf(file.path(pkg, "DESCRIPTION"))[, "Version"]
  message("Building source package ...")
  src <- devtools::build(pkg, path = here::here(), binary = FALSE)
  message(sprintf("Building binary package for %s", R.version$os))
  bin <- devtools::build(pkg, path = here::here(), binary = TRUE)
  

  for (i in repo) {
    message(sprintf("Adding source and binary to %", i))
    drat::insertPackage(src, 
                        action = "archive", 
                        repodir = i)

    drat::insertPackage(bin, 
                        action = "archive", 
                        repodir = i)
  }
  
  unlink(src)
  unlink(bin)
  return(NULL)
}
