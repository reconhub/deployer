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
  
  # We want to do two things:
  #
  # 1. find or build the tarball of pkg
  # 2. insert the tarball into the the repository and archive any old instances
  #    of the pkg
  #
  # The package can have three sources:
  #
  # 1. a directory on the user's machine (we must build it)
  # 2. a tarball on the user's machine (we must move it)
  # 3. a package on CRAN (we must download it)
  #
  # Once we have determined the above, we use drat::insertPackage() below to
  # update the repository. If the repository is large, this can take a couple of
  # seconds for the index to be updated.

  src  <- win <- mac <- elc <- NULL
  repo <- normalizePath(repo)

  stopifnot(file.exists(file.path(repo, 'src', 'contrib')))
  ext <- tools::file_ext(pkg)
  tmp <- tempdir()
  #
  # The package is a folder on the user's system
  if (ext == "" && dir.exists(pkg)) {
    vers <- read.dcf(file.path(pkg, "DESCRIPTION"))[, "Version"]
    message("Building source package ...")
    src <- pkg <- devtools::build(pkg, path = tmp, binary = FALSE)
  # The package is one the user wants to download
  } else if (ext == "" && internet) { 
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
  # The pkg is a binary file/tarball
  } else if (file.exists(pkg)) { 
    src <- pkg
  } else {
    stop(sprintf("%s doesn't appear to be a file or folder and I can't download it.", pkg))
  }

  # adding source package ------------------------------------------------------
  message(sprintf("Adding source package to %s", repo))
  drat::insertPackage(src, action = "archive", repodir = repo) 

  # adding windows package -----------------------------------------------------
  if (!is.null(win)) {
    message(sprintf("Adding windows package to %s", repo))
    try(drat::insertPackage(win, action = "archive", repodir = repo))
  }

  # adding macos package -----------------------------------------------------
  if (!is.null(mac)) {
    message(sprintf("Adding macos package to %s", repo))
    try(drat::insertPackage(mac, action = "archive", repodir = repo))
  }

  # adding macos.el-capitan package -----------------------------------------------------
  if (!is.null(mac)) {
    message(sprintf("Adding macos el-capitan package to %s", repo))
    try(drat::insertPackage(elc, action = "archive", repodir = repo))
  }
  # ----------------------------------------------------------------------------

  return(NULL)
}
