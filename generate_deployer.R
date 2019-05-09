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

message("Creating deployer...")
nomad::build("reconhub/deployer", out_dir)

message("Compressing the deployers...")

sys_tar <- Sys.which("tar")
tar(sprintf("%s_extra.tar", out_dir), file.path(out_dir, "extra"),
    extra_flags = "-v",
    tar = sys_tar)
tar(sprintf("%s_base.tar", out_dir), out_dir,
    extra_flags = sprintf("-v --exclude=%s/bin --exclude=%s/extra", out_dir),
    tar = sys_tar)
tar(sprintf("%s_windows.tar", out_dir), file.path(out_dir, "bin/windows"),
    extra_flags = "-v",
    tar = sys_tar)
tar(sprintf("%s_macosx.tar", out_dir), file.path(out_dir, "bin/macosx"),
    extra_flags = "-v",
    tar = sys_tar)

# calculate and print md5sums
the_tars  <- tools::md5sum(dir(pattern = "\\.tar$"))
print.tar <- function(x, ...) cat(paste0(x, '  ', names(x)), sep = "\n", ...)
class(the_tars) <- "tar"
the_tars
print.tar(the_tars, file = sprintf("%s_md5sum.txt", out_dir)



