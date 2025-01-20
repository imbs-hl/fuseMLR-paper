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
nvars <- matrix(data = NA, nrow = 2, ncol = 4, byrow = TRUE,
                dimnames = list(c("BLCA", "HNSC"),
                                c("CNV", "miRNA", "mRNA", "Mutation")))
# This code may need to be executed multiple times, as the server for retrieving
# chromosome information might be temporarily unavailable.
for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  load(file.path(data_dir, sprintf("%s.RData", nams[nam])))
  # Crossvalidation folds for benchmarking
  target_df <- data.frame(ID = surdata$bcr_patient_barcode,
                          sex = clindata$gender_MALE_clinical)
  set.seed(seeds[nam])
  bench_folds <- caret::createFolds(y = target_df$sex, k = 10L)
  res_list <- lapply(X = 1L:1L, FUN = function(current_fold){
    message(sprintf("Omics data: %s: fold: %s\n", nams[nam], current_fold))
    testing_index <- bench_folds[[current_fold]]
    # ==============================================================================
    # Prepare data modalities
    # ==============================================================================
    # Testing
    target_df_testing <- target_df[testing_index, ]
    # testing_clin <- data.frame(cbind(ID = target_df$ID[testing_index]),
    #                            clindata[testing_index, ])
    testing_cnv <- data.frame(cbind(ID = target_df$ID[testing_index]),
                              cnvdata[testing_index, ])
    testing_mirna <- data.frame(cbind(ID = target_df$ID[testing_index]),
                                scale(mirnadata[testing_index, ]))
    testing_rna <- data.frame(cbind(ID = target_df$ID[testing_index]),
                              scale(rnadata[testing_index, ]))
    testing_mutation <- data.frame(cbind(ID = target_df$ID[testing_index]),
                                   mutationdata[testing_index, ])
    # Training
    target_df_training <- target_df[-testing_index, ]
    # training_clin <- data.frame(cbind(ID = target_df$ID[- testing_index]),
    #                             clindata[ - testing_index, ])
    training_cnv <- data.frame(cbind(ID = target_df$ID[ - testing_index]),
                               cnvdata[ - testing_index, ])
    training_mirna <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                 scale(mirnadata[- testing_index, ]))
    training_rna <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                               scale(rnadata[- testing_index, ]))
    training_mutation <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                    mutationdata[- testing_index, ])
    # ==========================================================================
    # fuseMLR
    # ==========================================================================
    start_time <- proc.time()
    # Training
    training <- createTraining(id = "training",
                               ind_col = "ID",
                               target = "sex",
                               target_df = target_df_training,
                               verbose = TRUE)
    
    # Create CNV layer.
    createTrainLayer(training = training,
                     train_layer_id = "CNV",
                     train_data = training_cnv,
                     varsel_package = "Boruta",
                     varsel_fct = "Boruta",
                     varsel_param = list(num.trees = 2500L,
                                         probability = TRUE),
                     lrner_package = "ranger",
                     lrn_fct = "ranger",
                     param_train_list = list(probability = TRUE),
                     param_pred_list = list(),
                     na_action = "na.keep")
    
    # Create MiRNA layer.
    createTrainLayer(training = training,
                     train_layer_id = "MiRNA",
                     train_data = training_mirna,
                     varsel_package = "Boruta",
                     varsel_fct = "Boruta",
                     varsel_param = list(num.trees = 2500L,
                                         probability = TRUE),
                     lrner_package = NULL,
                     lrn_fct = "mysvm",
                     param_train_list = list(type = 'C-classification',
                                             kernel = 'radial',
                                             probability = TRUE),
                     param_pred_list = list(),
                     na_action = "na.keep")
    
    # Create RNA layer.
    createTrainLayer(training = training,
                     train_layer_id = "RNA",
                     train_data = training_rna,
                     varsel_package = "Boruta",
                     varsel_fct = "Boruta",
                     varsel_param = list(num.trees = 2500L,
                                         probability = TRUE),
                     lrner_package = NULL,
                     lrn_fct = "mysvm",
                     param_train_list = list(type = 'C-classification',
                                             kernel = 'radial',
                                             probability = TRUE),
                     param_pred_list = list(),
                     na_action = "na.keep")
    
    # Create mutation layer.
    createTrainLayer(training = training,
                     train_layer_id = "Mutation",
                     train_data = training_mutation,
                     varsel_package = "Boruta",
                     varsel_fct = "Boruta",
                     varsel_param = list(num.trees = 2500L,
                                         probability = TRUE),
                     lrner_package = "ranger",
                     lrn_fct = "ranger",
                     param_train_list = list(probability = TRUE),
                     param_pred_list = list(),
                     na_action = "na.keep")
    
    # Create meta-layer.
    createTrainMetaLayer(training = training,
                         meta_layer_id = "meta_layer",
                         lrner_package = NULL,
                         lrn_fct = "mylasso",
                         param_train_list = list(nlambda = 25,
                                                 nfolds = 10),
                         param_pred_list = list(),
                         na_action = "na.keep")
    selected_var <- varSelection(training = training)
    chrnams[nam, ] <- c(cnvdata_chr(data = cnvdata[ , selected_var[, "CNV"]]), 
                        mirna_chr(data = mirnadata[ , selected_var[, "MiRNA"]]),
                        mrna_chr(data = rnadata[ , selected_var[, "RNA"]]),
                        mutation_chr(data = mutationdata[ , selected_var[, "Mutation"]]))
    nvars[nam, ] <- c(ncol(cnvdata[ , selected_var[, "CNV"]]),
                      ncol(mirnadata[ , selected_var[, "MiRNA"]]),
                      ncol(rnadata[ , selected_var[, "RNA"]]),
                      ncol(mutationdata[ , selected_var[, "Mutation"]]))
    print(chrnams)
    print(chrnams / nvars)
    return(list(chrnams = chrnams, prop.chrnams = chrnams / nvars))
  })
}

