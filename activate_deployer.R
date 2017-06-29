## Script to activate the deployer; 'path' is the path to the RECON deployer
## folder. It will set up the deployer as local CRAN repository, and add a
## script for installing non-CRAN packages in the global environment.

activate_deployer <- function(path = getwd()) {

  ## Check that content is there

  expected <- c("bin", "drat", "extra", "src")
  present <- dir(path)
  missing <- expected[!expected %in% present]
  if (length(missing) > 0L) {
    msg <- paste("Folder \"", path, "\"",
                 "doesn't look like a RECON deployer.\n",
                 "\nThe following elements are missing:\n",
                 paste(missing, collapse = ", "),
                 "\n\nPlease check the path and try again."
                 )
    stop(msg)
  }


  ## check sha1 hash of all files in bin/drat/extra/src
  if (!require(digest)) {
    msg <- "'digest' not installed - cannot verify checksum"
    warning(msg)
  } else {
    hash <- digest::sha1(dir(expected, recursive = TRUE))
    ref <- "379cb9b5a585b9c7c4340a644c4f189f3aecaef8"
    if (!identical(ref, hash)) {
      warning("sha1 signature is wrong - integrity of deployer compromised")
    } else {
      message("  // sha1 signature verified")
    }
  }


  ## Set up RECON deployer as default package repository:

  deployer_dir <- paste0("file:///", normalizePath(path))
  deployer_dir <- sub("file:////", "file:///", deployer_dir)
  options(repos = deployer_dir)
  message("  // setting deployer as local CRAN respository")


  install_devel <- function(pkg) {
    devel_dir <- normalizePath(
      paste(path,
            "drat/src/contrib/", sep = "/"))

    pkg_src <- dir(devel_dir, pattern = pkg, full = TRUE)
    if (length(pkg_src) == 0L) {
      stop("package", pkg_src, "not found")
    }
    install.packages(pkg_src, type = "source", repos = NULL)
  }

  assign("install_devel", install_devel, envir = .GlobalEnv)
  message("  // adding 'install_devel' function to global environment")
  cat("\n")
  message("Example to install CRAN package 'outbreaks':")
  message("install.packages(\"outbreaks\")")
  cat("\n")
  message("Example to install devel package 'earlyR':")
  message("install_devel(\"earlyR\")")

}
