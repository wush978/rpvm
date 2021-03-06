
if (Sys.getenv("TEST_PVM") != "TRUE") quit("no")
library(pvm)
options(repos = c(CRAN = "http://cloud.r-project.org/"))
lib.loc <- tempfile(fileext = ".lib")
dir.create(lib.loc, showWarnings = FALSE)
Sys.setenv("R_TESTS" = "")
utils::install.packages("RcppCNPy", lib = lib.loc)
pvm <- export.packages(lib.loc = c(lib.loc, .libPaths()))
print(installed.packages(lib.loc = c(lib.loc, .libPaths()))["Rcpp",])
obj <- yaml::yaml.load_file("pvm.yml")
stopifnot(obj[["__version__"]] == "0.2")
obj <- obj[Filter(function(x) x != "__version__", names(obj))]
names(obj) <- NULL
obj <- unlist(obj)
result <- lapply(c("Rcpp", "RcppCNPy"), function(pkg) {
  cat(sprintf("Checking version of %s\n", pkg))
  cat(sprintf("Exported version is: %s\n", v1 <- obj[[pkg]]))
  cat(sprintf("Original version is: %s\n", v2 <- packageVersion(pkg, c(lib.loc, .libPaths()))))
  stopifnot(v1 == v2)
  invisible(NULL)
})
