# install.packages("OpenML")
# install.packages("farff")
# install.packages("readr")

library(OpenML)
library(farff)
library(readr)

# Set your working directory to the project directory.

load("datset_ids.RData")
dir.create("data", showWarnings = FALSE)
setwd("data")
getwd()
nams <- c("BLCA", "HNSC")

for(nam in nams){
  # download dataset
  dat_part1 <- getOMLDataSet(datset_ids[[nam]][[1]])
  dat_part2 <- getOMLDataSet(datset_ids[[nam]][[2]])

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
       file = paste(nam,".RData", sep = ""))
}
