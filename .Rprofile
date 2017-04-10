.First <- function() {
    if (interactive()) {
        options("repos" = c(CRAN="http://cran.uk.r-project.org",
                CRANextra="http://www.stats.ox.ac.uk/pub/RWin")
                )
    }
    myRVersion <- sub(".*/R/([^/]*)/.*", "\\1", .libPaths()[grepl("/camp/apps/eb", .libPaths())])
    .libPaths(c(file.path("/camp/stp/babs/working", Sys.info()["user"], "code/R/library",with(R.Version(), paste(major, minor, sep="."))),
                file.path("/camp/stp/babs/working/software/binaries/R-site-library", myRVersion))
              )
}

#source("http://bioconductor.org/biocLite.R")
