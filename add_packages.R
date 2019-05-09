imsg <- "Usage: Rscript add_packages.R [...]
        Arguments:
            [...] a list of R packages to add to package_list.txt, separated by
                  whitespace
        Examples:
        Rscript zkamvar.R fuzzyjoin kableExtra
"
args <- commandArgs(trailingOnly = TRUE)
if (is.na(args[1])) stop(imsg)
punct <- grepl("[[:punct:]]", args)
if (any(punct)) {
  pkgs <- paste(args[punct], collapse = "\n")
  message(sprintf("The following packages may need to be added to package_sources.txt:\n%s", pkgs)) 
  args <- args[!punct]
}

pkglist  <- readLines("package_list.txt")
pkgs     <- unique(sort(c(args, pkglist)))
new_pkgs <- setdiff(pkgs, pkglist)

message(paste("new package added:", new_pkgs, collapse = "\n"))

cat(pkgs, sep = "\n", file = "package_list.txt")


