#' Update a package in a deployer from the source code
#'
#' @param pkg the path to a package source
#' @param repo path to a drat repo. Defaults to the current  repo 
#' @param internet a future parameter to update packages from internet if it is
#'   available.
#' @examples
#'
#' update_package("../linelist") # update the linelist package, assuming its
#'   source lives one directory upstream of this deployer
#'
#' # download and insert the binary and windows packages for prettydoc
#' deploy_package("prettydoc", internet = TRUE, windows = TRUE)
update_package <- function(pkg = NULL, repo = ".", internet = FALSE, windows = TRUE, macos = FALSE, el.capitan = macos) {
  if (is.null(pkg)) {
    msg <- paste(
                 "Please supply a path to a package source"
    )
    stop(msg)
  }
  src <- win <- mac <- elc <- NULL
  stopifnot(file.exists(file.path(repo, 'src', 'contrib')))
  ext <- tools::file_ext(pkg)
  tmp <- tempdir()
  #
  # The package is a folder on the user's directory
  if (ext == "" && dir.exists(pkg)) {
    vers <- read.dcf(file.path(pkg, "DESCRIPTION"))[, "Version"]
    message("Building source package ...")
    pkg <- devtools::build(pkg, path = tmp, binary = FALSE)
  } else if (ext == "" && internet) { # The package is one the user wants to download
    message("Downloading the source package from CRAN ...")
    try(src <- download.packages(pkg, type = "source", destdir = tmp)[2])
    if (windows) { 
      try(win <- download.packages(pkg, type = "win.binary", destdir = tmp)[2])
    }
    if (macos) {
      try(mac <- download.packages(pkg, type = "mac.binary", destdir = tmp)[2])
    }
    if (el.capitan) {
      try(elc <- download.packages(pkg, type = "mac.binary.el-capitan", destdir = tmp)[2])
    }
  } else if (file.exists(pkg)) { # The file is a binary
    src <- pkg
  } else {
    stop(sprintf("%s doesn't appear to be a file or folder and I can't download it.", pkg))
  }

  # adding source package ------------------------------------------------------
  message(sprintf("Adding source package and to %s", repo))
  drat::insertPackage(src, action = "archive", repodir = repo) 

  # adding windows package -----------------------------------------------------
  if (!is.null(win)) {
    message(sprintf("Adding windows package and to %s", repo))
    try(drat::insertPackage(win, action = "archive", repodir = repo))
  }

  # adding macos package -----------------------------------------------------
  if (!is.null(mac)) {
    message(sprintf("Adding macos package and to %s", repo))
    try(drat::insertPackage(mac, action = "archive", repodir = repo))
  }

  # adding macos.el-capitan package -----------------------------------------------------
  if (!is.null(mac)) {
    message(sprintf("Adding macos el-capitan package and to %s", repo))
    try(drat::insertPackage(elc, action = "archive", repodir = repo))
  }
  # ----------------------------------------------------------------------------

  return(NULL)
}
