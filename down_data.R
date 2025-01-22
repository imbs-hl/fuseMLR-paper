# Omics-data are downloaded from the OpenML server hosted by the Technical
# University (TU) of Eindhoven.

# Set your working directory to the project directory.  
setwd(data_dir)
load("datset_ids.RData")
nams <- c("BLCA", "HNSC")

for(nam in nams){
  # Download dataset
  # We try the OpenML server and the read only instance temporary deployed for
  # solve the issue due to cyberattack the TU of Eindhoven recently had.
  dat_part1 <- NULL
  dat_part2 <- NULL
  # Try to download data from the OpenML server.
  try({
    dat_part1 <- getOMLDataSet(datset_ids[[nam]][[1]])
    dat_part2 <- getOMLDataSet(datset_ids[[nam]][[2]])
  }, silent = FALSE)
  # Try to download data from the temporary read-only instance on
  # http://145.38.195.79/
  if (is.null(dat_part1)) {
    setOMLConfig(server = "http://145.38.195.79/api/v1/xml")
    dat_part1 <- getOMLDataSet(datset_ids[[nam]][[1]])
    dat_part2 <- getOMLDataSet(datset_ids[[nam]][[2]])
  }
  dat <- cbind.data.frame(dat_part1, dat_part2)
  blocknames <- c("clinical", "cnv", "mirna", "mutation", "rna")
  blockinds <- lapply(paste0("_", blocknames), function(x) grep(x, names(dat)))
  clindata <- dat[,blockinds[[1]]]
  cnvdata <- dat[,blockinds[[2]]]
  mirnadata <- dat[,blockinds[[3]]]
  mutationdata <- dat[,blockinds[[4]]]
  rnadata <- dat[,blockinds[[5]]]
  surdata <- dat[,1:3]
  save(clindata, cnvdata, mirnadata,mutationdata, rnadata,surdata,
       file = paste(nam, ".RData", sep = ""))
}
