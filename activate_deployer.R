## Script to activate the deployer; 'path' is the path to the RECON deployer
## folder. It will set up the deployer as local CRAN repository, and add a
## script for installing non-CRAN packages in the global environment.

activate_deployer <- function(path = getwd(), use_local_lib = FALSE,
                              check_integrity = TRUE) {

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
    if (check_integrity) {
        if (!require(digest)) {
            msg <- "'digest' not installed - cannot verify checksum"
            warning(msg)
        } else {
            folders_to_check <- paste(normalizePath(path, winslash = "/"),
                                      expected, sep = "/")
     
            hash <- digest::sha1(dir(folders_to_check, recursive = TRUE))
            ref <- "3601375addcaf651235ed5bf1e4d6aeed25c1bb0"
            if (!identical(ref, hash)) {
                message("\n/// Checking deployer integrity: wrong sha1 signature detected.")
                warning("sha1 signature is wrong - integrity of deployer may be compromised")
            } else {
                message("\n/// Checking deployer integrity: all good!")
            }
        }
    }

    
    ## Set up RECON deployer as default package repository:

    deployer_dir <- paste0("file:///", normalizePath(path))
    deployer_dir <- sub("file:////", "file:///", deployer_dir)
    options(repos = deployer_dir)
    
    message("\n/// Setting deployer as local cran respository //")
    message("// packages will be installed from: ")
    message(deployer_dir)


    ## set local lib in deployer folder

    if (use_local_lib) {    
        new_lib_path <- paste(normalizePath(path, winslash = "/"),
                              "library", sep = "/")
        
        if (!dir.exists(new_lib_path)) {
            dir.create(new_lib_path)
        }
        .libPaths(c(new_lib_path, .libPaths()))

        message("\n/// Setting up new library in the deployer folder //")
        message("// packages will be installed by default in:")
        message(new_lib_path)
    }

    message("\n/// Examples: installing packages //")
    message("// install CRAN package 'outbreaks':")
    message("install.packages(\"outbreaks\")")
    message("\n// install devel package 'earlyR':")
    message("install.packages(\"earlyR\")\n")

}
