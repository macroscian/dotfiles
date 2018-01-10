.First <- function() {
    if (interactive()) {
        options("repos" = c(CRAN="http://cran.uk.r-project.org",
                CRANextra="http://www.stats.ox.ac.uk/pub/RWin")
                )
    }
    myRVersion <- sub(".*/R/([^/]*)/.*", "\\1", .libPaths()[grepl("/camp/apps/eb", .libPaths())])
    myRLIB <- file.path("/camp/stp/babs/working", Sys.info()["user"], "code/R/library",with(R.Version(), paste(major, minor, sep=".")))
    if (!dir.exists(myRLIB)) {
      dir.create(myRLIB)
    }
    .libPaths(c(myRLIB,
                file.path("/camp/stp/babs/working/software/binaries/R-site-library", myRVersion))
              )
	      
}

setHook(packageEvent("grDevices", "onLoad"),
        function(...) grDevices::X11.options(type='cairo'))
options(device='x11')

