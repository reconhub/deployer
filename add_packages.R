imsg <- "Usage: Rscript add_packages.R [...]
        Arguments:
            [...] a list of R packages to add to package_list.txt, separated by
                  whitespace
        Examples:
        Rscript zkamvar.R fuzzyjoin kableExtra
"
args <- commandArgs(trailingOnly = TRUE)
if (is.na(args[1])) stop(imsg)
pkglist <- readLines("package_list.txt")
cat(sort(c(args, pkglist)), sep = "\n", file = "package_list.txt")
