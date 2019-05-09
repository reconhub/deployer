msg <- "

Generate a RECON deployer to go.

This script will do the following:

1. attempt to upgrade provisioner and nomad
2. generate the deployer
3. split the deployer into 4 compressed files with md5sums that can be uploaded
   to github for release

The files you end up with are:

<name>_base.tar source packages, cheat sheets, and instructions
<name>_extra.tar binaries for R, git, Rtools, and RStudio
<name>_macosx.tar binary packages built for macos
<name>_windows.tar binary packages built for windows
<name>_md5sums.txt summary of the above files
<name>_release.md release page to be placed on github

Once downloaded, these can be decompressed via R:

untar('<name>_base.tar')
untar('<name>_extra.tar')
untar('<name>_macosx.tar')
untar('<name>_windows.tar')

Usage: Rscript generate_deployer.R <name>

        Arguments:
        <name> the name of the new directory in which to create the deployer.
               This defaults to deployer_yyyy_mm_dd

"

args <- commandArgs(trailingOnly = TRUE)

out_dir <- if (is.na(args[1])) sprintf("deployer_%s", gsub("-", "_", Sys.Date())) else args[1]

# Updating packages ------------------------------------------------------------

message("Updating provisionr and nomad...")

if (!require("remotes")) {
  install.packages("remotes")
  library("remotes")
}

remotes::install_github("mrc-ide/provisionr", upgrade = FALSE)
remotes::install_github("reconhub/nomad", upgrade = FALSE)

# Deployer creation ------------------------------------------------------------

message("Creating deployer...")

nomad::build("reconhub/deployer", out_dir)

# Compress deployers -----------------------------------------------------------

message("Compressing the deployers...")

sys_tar <- Sys.which("tar")
tar(sprintf("%s_extra.tar", out_dir), file.path(out_dir, "extra"),
    extra_flags = "-v",
    tar = sys_tar)
tar(sprintf("%s_base.tar", out_dir), out_dir,
    extra_flags = sprintf("-v --exclude=%s/bin --exclude=%s/extra", out_dir, out_dir),
    tar = sys_tar)
tar(sprintf("%s_windows.tar", out_dir), file.path(out_dir, "bin/windows"),
    extra_flags = "-v",
    tar = sys_tar)
tar(sprintf("%s_macosx.tar", out_dir), file.path(out_dir, "bin/macosx"),
    extra_flags = "-v",
    tar = sys_tar)

# Calculate md5 sums -----------------------------------------------------------

message("Calculating md5 sums and writing %s_md5sum.txt ...", out_dir)

the_tars  <- tools::md5sum(dir(pattern = sprintf("^%s_(base|windows|macosx|extra)\\.tar$", out_dir)))
print.tar <- function(x, ...) cat(paste0(x, '  ', names(x)), sep = "\n", ...)
class(the_tars) <- "tar"
the_tars
print.tar(the_tars, file = sprintf("%s_md5sum.txt", out_dir))

# Creating release markdown document -------------------------------------------

message("Creating %s_release.md...", out_dir)

cat("

   Produced by <GITHUB_NAME> via:

```sh
Rscript generate_deployer.R
```

## Installation

Download the *.tar files in this release.

Expected MD5 hash:

```", 

paste0(the_tars, '  ', names(the_tars)),

"```

Please confirm to avoid issues with corrupted downloads. You can do this with

```r",

sprintf("md5file <- '%s_md5sum.txt'", out_dir),

"inlines <- readLines(md5file)
xx <- sub(\"^([0-9a-fA-F]*)(.*)\", \"\\\\1\", inlines)
nmxx <- names(xx) <- sub(\"^[0-9a-fA-F]* [ |*](.*)\", \"\\\\1\", inlines)
print.tar <- function(x, ...) cat(paste0(x, '  ', names(x)), sep = '\\n', ...)",

sprintf("the_tars  <- tools::md5sum(dir(pattern = '^%s_(base|windows|macosx|extra)\\\\.tar$'))", out_dir),

"
class(the_tars) <- 'tar'
class(xx) <- 'tar'

the_tars
xx

identical(xx, the_tars)
```

(this will take several seconds to run)

To put back together, download these files and then run:

```r",

sprintf("untar('deployer_%s_base.tar')", out_dir),
sprintf("untar('deployer_%s_windows.tar')", out_dir),
sprintf("untar('deployer_%s_macosx.tar')", out_dir),
sprintf("untar('deployer_%s_extra.tar')", out_dir),

"``` 
    
", file = sprintf("%s_release.md", out_dir), sep = "\n")


cat("

    Please upload the tar files and md5sums to the deployer github release
    page:

    https://github.com/reconhub/deployer/releases/new

    Make sure you add the release notes and tag yourself in the release.

")

