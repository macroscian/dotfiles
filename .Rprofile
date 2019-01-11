.First <- function() {
    if (interactive()) {
        options("repos" = c(CRAN="http://cran.uk.r-project.org",
                CRANextra="http://www.stats.ox.ac.uk/pub/RWin")
                )
        options(device=function (...) grDevices::X11(...,type='cairo'))
        options(bitmapType = 'cairo')
    }
    myRVersion <- sub(".*/R/([^/]*)/.*", "\\1", .libPaths()[grepl("/camp/apps/eb", .libPaths())])
    myRLIB <- file.path("/camp/stp/babs/working", Sys.info()["user"], "code/R/library",with(R.Version(), paste(major, minor, sep=".")))
    if (!dir.exists(myRLIB)) {
      dir.create(myRLIB)
    }
    .libPaths(c(myRLIB,
                file.path("/camp/stp/babs/working/software/binaries/R-site-library", myRVersion))
              )
    setHook(packageEvent("DESeq2", "onLoad"),
            function(...) {
              res <- utils::getFromNamespace("results", "DESeq2")
              formals(res) <- formals(res)[names(formals(res))!="..."]
              utils::assignInNamespace("results",res, "DESeq2")
            })
}

## setHook(packageEvent("grDevices", "onLoad"),
##         function(...) grDevices::X11.options(type='cairo'))

install.packages.gpk <- function(x) {
  x <- as.character(substitute(x))
  if (x %in% row.names(available.packages())) {
    install.packages(x)
  } else {
    source("http://bioconductor.org/biocLite.R")
    biocLite(x)
  }
}	
