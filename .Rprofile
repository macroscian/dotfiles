.First <- function() {
    if (interactive()) {
        options("repos" = c(CRAN="http://cran.uk.r-project.org",
                CRANextra="http://www.stats.ox.ac.uk/pub/RWin")
                )
        options(device=function (...) grDevices::X11(...,type='cairo'))
        options(bitmapType = 'cairo')
    }
    lpaths <- .libPaths()
    myRVersion <- sub(".*/R/([^/]*)/.*", "\\1", .libPaths()[grepl("/camp/apps", lpaths)])[1]
    myRLIB <- file.path("/camp/stp/babs/working", Sys.info()["user"], "code/R/library",with(R.Version(), paste(major, minor, sep=".")))
    lpaths[grepl("/camp/apps/eb", lpaths)] <- file.path("/camp/stp/babs/working/software/binaries/R-site-library", myRVersion)
    if (!dir.exists(myRLIB)) {
      dir.create(myRLIB)
    }
    .libPaths(c(myRLIB,unique(lpaths)))
    setHook(packageEvent("DESeq2", "onLoad"),
            function(...) {
              res <- utils::getFromNamespace("results", "DESeq2")
              formals(res) <- formals(res)[names(formals(res))!="..."]
              utils::assignInNamespace("results",res, "DESeq2")
            })
}


install.packages.gpk <- function(x) {
  x <- as.character(substitute(x))
  if (x %in% row.names(available.packages())) {
    install.packages(x)
  } else {
    if (as.integer(R.Version()$year)>=2019) {
      BiocManager::install(x)
    } else{
      source("http://bioconductor.org/biocLite.R")
      biocLite(x)
    }
  }
}	
