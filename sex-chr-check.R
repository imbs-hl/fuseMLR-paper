# Function to retrieve the number of miRNA samples from chromosome X.
mirna_chr <- function (data = mirnadata) {
  x <- mirbaseCHR
  # Get the microRNA identifiers that are mapped to a chromosome
  mapped_keys <- mappedkeys(x)
  # Convert to a list
  xx <- as.list(x[mapped_keys])
  simple_names <- new_names <- gsub(pattern = "_mirna",
                                    replacement = "",
                                    x = names(data))
  new_names <- gsub(pattern = "\\.", replacement = "-", x = simple_names)
  table(tmp_chr)["chrX"]
}

# Function to retrieve the number of mRNA samples from chromosome X
mrna_chr <- function (data = rnadata) {
  simple_names <- new_names <- gsub(pattern = "_rna",
                                    replacement = "",
                                    x = names(data))
  if (!exists("mart")) {
    mart <- useEnsembl(biomart = "ensembl",
                       dataset = "hsapiens_gene_ensembl",
                       mirror = "useast")
  }
  result <- getBM(
    attributes = c("ensembl_gene_id", "chromosome_name"),
    filters = "ensembl_gene_id",
    values = simple_names,  # Change this to the desired gene ID
    mart = mart
  )
  return(table(result$chromosome_name)["X"])
}

# Function to retrieve the number of mutation samples from chromosome X
mutation_chr <- function (data = mutationdata) {
  simple_names <- new_names <- gsub(pattern = "_mutation",
                                    replacement = "",
                                    x = names(data))
  if (!exists("mart")) {
    mart <- useEnsembl(biomart = "ensembl",
                       dataset = "hsapiens_gene_ensembl",
                       mirror = "useast")
  }
  result <- getBM(
    attributes = c("ensembl_gene_id", "chromosome_name"),
    filters = "external_gene_name",
    values = simple_names,  # Change this to the desired gene ID
    mart = mart
  )
  return(table(result$chromosome_name)["X"])
}


# Function to retrieve the number of CNV samples from chromosome X
cnvdata_chr <- function (data = cnvdata) {
  simple_names <- new_names <- gsub(pattern = "_cnv",
                                    replacement = "",
                                    x = names(data))
  if (!exists("mart")) {
    mart <- useEnsembl(biomart = "ensembl",
                       dataset = "hsapiens_gene_ensembl",
                       mirror = "useast")
  }
  result <- getBM(
    attributes = c("ensembl_gene_id", "chromosome_name"),
    filters = "ensembl_gene_id",
    values = simple_names,  # Change this to the desired gene ID
    mart = mart
  )
  return(table(result$chromosome_name)["X"])
}

###############################################################################
## Set path
######
project_dir <- "~/projects/interconnect-publications/fuseMLR-paper"
dir.create(path = file.path(project_dir, "results"),
           recursive = TRUE,
           showWarnings = FALSE)
result_dir <- file.path(project_dir, "results")
data_dir <- file.path(project_dir, "data")


nams <- c("BLCA", "HNSC")
seeds <- c(422852, 342303)
chrnams <- matrix(data = NA, nrow = 2, ncol = 4, byrow = TRUE,
                  dimnames = list(c("BLCA", "HNSC"),
                                  c("CNV", "miRNA", "mRNA", "Mutation")))
# This code may need to be executed multiple times, as the server for retrieving
# chromosome information might be temporarily unavailable.
for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  load(file.path(data_dir, sprintf("%s.RData", nams[nam])))
  chrnams[nam, ] <- c(cnvdata_chr(data = cnvdata), 
                  mirna_chr(data = mirnadata),
                  mrna_chr(data = rnadata),
                  mutation_chr(data = mutationdata))
}

print(chrnams)
