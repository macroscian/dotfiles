.First <- function() {
    if (interactive()) {
        options("repos" = c(CRAN="http://cran.uk.r-project.org",
                CRANextra="http://www.stats.ox.ac.uk/pub/RWin")
                )
       setHook(packageEvent("grDevices", "onLoad"),
              function(...) grDevices::X11.options(type="nbcairo"))
#        source("http://bioconductor.org/biocLite.R")
    }
}

source("http://bioconductor.org/biocLite.R")
