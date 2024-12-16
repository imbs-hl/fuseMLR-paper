# devtools::install_github("imbs-hl/fuseMLR")
# install.packages("ranger")
# install.packages("glmnet")
# install.packages("e1071")

library(fuseMLR)
library(ranger)
library(glmnet)
library(e1071)
library(data.table)
library(ggplot2)

# Result directory
project_dir <- "~/projects/interconnect-publications/fusemlr/TCGA"
dir.create(path = file.path(project_dir, "results"),
           recursive = TRUE,
           showWarnings = FALSE)
result_dir <- file.path(project_dir, "results")
data_dir <- file.path(project_dir, "data")

source(file.path(project_dir, "mylasso.R"))
source(file.path(project_dir, "mysvm.R"))

# nams <- c("COAD", "PAAD", "SARC")
nams <- c("BLCA", "HNSC")
seeds <- c(4282, 4233)

for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  load(file.path(data_dir, sprintf("%s.RData", nams[nam])))
  # Crossvalidation folds for benchmarking
  target_df <- data.frame(ID = surdata$bcr_patient_barcode,
                          mutation = mutationdata$TP53_mutation)
  # Remove target from mutation modality
  mutationdata$TP53_mutation <- NULL
  # Start cross-validation for benchmarking
  set.seed(seeds[nam])
  bench_folds <- caret::createFolds(y = target_df$mutation, k = 10L)
  res_list <- lapply(X = 1L:10L, FUN = function(current_fold){
    message(sprintf("Omics data: %s: fold: %s\n", nams[nam], current_fold))
    testing_index <- bench_folds[[current_fold]]
    # ==============================================================================
    # Prepare data modalities
    # ==============================================================================
    # Testing
    target_df_testing <- target_df[testing_index, ]
    testing_clin <- data.frame(cbind(ID = target_df$ID[testing_index]),
                               clindata[testing_index, ])
    testing_cnv <- data.frame(cbind(ID = target_df$ID[testing_index]),
                              cnvdata[testing_index, ])
    testing_mirna <- data.frame(cbind(ID = target_df$ID[testing_index]),
                                mirnadata[testing_index, ])
    testing_rna <- data.frame(cbind(ID = target_df$ID[testing_index]),
                              rnadata[testing_index, ])
    testing_mutation <- data.frame(cbind(ID = target_df$ID[testing_index]),
                                   mutationdata[testing_index, ])

    # Training
    target_df_training <- target_df[-testing_index, ]
    training_clin <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                clindata[ - testing_index, ])
    training_cnv <- data.frame(cbind(ID = target_df$ID[ - testing_index]),
                               cnvdata[ - testing_index, ])
    training_mirna <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                 mirnadata[- testing_index, ])
    training_rna <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                               rnadata[- testing_index, ])
    training_mutation <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                    mutationdata[- testing_index, ])

    # ==========================================================================
    # fuseMLR
    # ==========================================================================
    #
    # Training
    training <- Training$new(id = "training",
                             ind_col = "ID",
                             target = "mutation",
                             target_df = target_df_training)

    # Set up layers
    trainlay_clin <- TrainLayer$new(id = "Clinical", training = training)
    trainlay_cnv <- TrainLayer$new(id = "CNV", training = training)
    trainlay_mirna <- TrainLayer$new(id = "MiRNA", training = training)
    trainlay_rna <- TrainLayer$new(id = "RNA", training = training)
    trainlay_mutation <- TrainLayer$new(id = "Mutation", training = training)
    # We also prepare the meta layer for the meta analysis.
    trainlay_meta <- TrainMetaLayer$new(id = "Meta_layer", training = training)

    # Set ut data modalities
    train_data_clin <- TrainData$new(id = "Clin_modality",
                                     train_layer = trainlay_clin,
                                     data_frame = training_clin)
    train_data_cnv <- TrainData$new(id = "CNV_modality",
                                    train_layer = trainlay_cnv,
                                    data_frame = training_cnv)
    train_data_mirna <- TrainData$new(id = "MiRNA_modality",
                                      train_layer = trainlay_mirna,
                                      data_frame = training_mirna)
    train_data_rna <- TrainData$new(id = "RNA_modality",
                                    train_layer = trainlay_rna,
                                    data_frame = training_rna)
    train_data_mutation <- TrainData$new(id = "Mutation_modality",
                                         train_layer = trainlay_mutation,
                                         data_frame = training_mutation)

    # Set up variable selection method
    same_param_varsel <- ParamVarSel$new(id = "ParamVarSel",
                                         param_list = list(num.trees = 5000L,
                                                           probability = TRUE))
    # No variable selection for the clinical modality
    varsel_cnv <- VarSel$new(id = "varsel_cnv",
                             package = "Boruta",
                             varsel_fct = "Boruta",
                             param = same_param_varsel,
                             train_layer = trainlay_cnv)
    varsel_mirna <- VarSel$new(id = "varsel_mirna",
                               package = "Boruta",
                               varsel_fct = "Boruta",
                               param = same_param_varsel,
                               train_layer = trainlay_mirna)
    varsel_rna <- VarSel$new(id = "varsel_rna",
                             package = "Boruta",
                             varsel_fct = "Boruta",
                             param = same_param_varsel,
                             train_layer = trainlay_rna)
    varsel_mutation <- VarSel$new(id = "varsel_mutation",
                                  package = "Boruta",
                                  varsel_fct = "Boruta",
                                  param = same_param_varsel,
                                  train_layer = trainlay_mutation)

    # Learning
    # Learner parameters
    ranger_param <- ParamLrner$new(id = "ParamRanger",
                                   param_list = list(probability = TRUE),
                                   hyperparam_list = list(num.trees = 5000L))
    svm_param <- ParamLrner$new(id = "ParamSVM",
                                param_list = list(type = 'C-classification',
                                                  kernel = 'radial',
                                                  #gamma = g,cost=c,
                                                  probability = TRUE),
                                hyperparam_list = list())

    # Set up learners
    ranger_clin <- Lrner$new(id = "ranger_clin",
                             package = "ranger",
                             lrn_fct = "ranger",
                             param = ranger_param,
                             train_layer = trainlay_clin)
    ranger_cnv <- Lrner$new(id = "ranger_cnv",
                            package = "ranger",
                            lrn_fct = "ranger",
                            param = ranger_param,
                            train_layer = trainlay_cnv)
    svm_mirna <- Lrner$new(id = "svm_mirna",
                           package = "ranger",
                           lrn_fct = "ranger",
                           param = ranger_param,
                           train_layer = trainlay_mirna)
    svm_rna <- Lrner$new(id = "svm_rna",
                         lrn_fct = "mysvm",
                         param = svm_param,
                         train_layer = trainlay_rna)
    svm_mutation <- Lrner$new(id = "svm_mutation",
                              lrn_fct = "mysvm",
                              param = svm_param,
                              train_layer = trainlay_mutation)
    # svm_rna <- Lrner$new(id = "svm_rna",
    #                      package = "ranger",
    #                      lrn_fct = "ranger",
    #                      param = ranger_param,
    #                      train_layer = trainlay_rna)
    # svm_mutation <- Lrner$new(id = "svm_mutation",
    #                           package = "ranger",
    #                           lrn_fct = "ranger",
    #                           param = ranger_param,
    #                           train_layer = trainlay_mutation)
    # Set up meta learner
    lasso_meta <- Lrner$new(id = "Lasso_meta",
                            lrn_fct = "mylasso",
                            param = ParamLrner$new(id = "Mylasso",
                                                   param_list = list(nlambda = 100L),
                                                   hyperparam_list = list()),
                            na_rm = FALSE,
                            train_layer = trainlay_meta)

    # Perform variable selection
   var_sel_res <- training$varSelection()

    # Train models
    training$train(resampling_method = "caret::createFolds",
                   resampling_arg = list(y = target_df_training$mutation,
                                         k = 10L),
                   use_var_sel = TRUE)

    # Testing
    testing <- Testing$new(id = "testing",
                           ind_col = "ID")

    # Set up layers
    teslay_clin <- TestLayer$new(id = "Clinical", testing = testing)
    teslay_cnv <- TestLayer$new(id = "CNV", testing = testing)
    teslay_mirna <- TestLayer$new(id = "MiRNA", testing = testing)
    teslay_rna <- TestLayer$new(id = "RNA", testing = testing)
    teslay_mutation <- TestLayer$new(id = "Mutation", testing = testing)

    # Set up data modalities
    test_data_clin <- TestData$new(id = "Clin_modality",
                                   new_layer = teslay_clin,
                                   data_frame = testing_clin)
    test_data_cnv <- TestData$new(id = "CNV_modality",
                                  new_layer = teslay_cnv,
                                  data_frame = testing_cnv)
    test_data_mirna <- TestData$new(id = "MiRNA_modality",
                                    new_layer = teslay_mirna,
                                    data_frame = testing_mirna)
    test_data_rna <- TestData$new(id = "RNA_modality",
                                  new_layer = teslay_rna,
                                  data_frame = testing_rna)
    test_data_mutation <- TestData$new(id = "Mutation_modality",
                                       new_layer = teslay_mutation,
                                       data_frame = testing_mutation)

    # Predicting
    tmp_pred <- training$predict(testing = testing)
    pred_truth <- data.frame(cbind(Multiomics = nam,
                                   tmp_pred$predicted_values,
                                   Truth = target_df_testing$mutation
    ))
    # Resume results
    fold_list <- list(training = training,
                      testing = testing,
                      pred_truth = pred_truth)

    # Save the fold
    saveRDS(
      object = fold_list,
      file = file.path(result_dir,
                       sprintf("%s_fold%02d.rds",
                               nams[nam],
                               current_fold))
    )

    return(fold_list)
  })
}


# Performance estimation
#TODO: remove this line later
result_dir <- "/imbs/home/fouodo/projects/interconnect-publications/fusemlr/TCGA/results"
all_res <- list()
for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  # load(file.path(data_dir, sprintf("%s.RData", nams[nam])))
  # # Crossvalidation folds for benchmarking
  # target_df <- data.frame(ID = surdata$bcr_patient_barcode,
  #                         mutation = mutationdata$TP53_mutation)
  # # Remove target from mutation modality
  # mutationdata$TP53_mutation <- NULL
  # Start cross-validation for benchmarking
  perf_list <- lapply(X = 1L:10L, FUN = function(current_fold){
    # Save the fold
    tmp_res <- readRDS(
      file.path(result_dir,
                sprintf("%s_fold%02d.rds",
                        nams[nam],
                        current_fold))
    )
    tmp_res <- tmp_res$pred_truth
    brier_score <- sapply(3:8, function (layer) {
      # clin_brier <- mean(((tmp_res[ , "Clinical"]) - tmp_res[ , 9])^2)
      # cnv_brier <- mean(((tmp_res[ , "CNV"]) - tmp_res[ , 9])^2)
      # mirna_brier <- mean(((tmp_res[ , "MiRNA"]) - tmp_res[ , 9])^2)
      # rna_brier <- mean(((tmp_res[ , "RNA"]) - tmp_res[ , 9])^2)
      # mutation_brier <- mean(((tmp_res[ , "Mutation"]) - tmp_res[ , 9])^2)
      # meta_brier <- mean((tmp_res[ , "meta_layer"] - tmp_res[ , 9])^2)
      # brier_score <- c(clin_brier,
      #                  cnv_brier,
      #                  mirna_brier,
      #                  rna_brier,
      #                  mutation_brier,
      #                  meta_brier)
      tmp_brier1 <- mean((tmp_res[ , layer] - tmp_res[ , 9])^2)
      tmp_brier2 <- mean((1- (tmp_res[ , layer]) - tmp_res[ , 9])^2)
      # return(c(clin_brier,
      #           cnv_brier,
      #           mirna_brier,
      #           rna_brier,
      #           mutation_brier,
      #           meta_brier))
      # ModelMetrics::brier(tmp_res[ , 8], tmp_res[ , layer])
      return(min(tmp_brier1, tmp_brier2))
    })
    names(brier_score) <- names(tmp_res)[3:8]
    return(brier_score)
  })
  perf_list <- as.data.table(do.call(what = "rbind", perf_list))
  perf_list$Data <- nams[nam]
  perf_long <- data.table::melt(data = perf_list,
                                id.vars = "Data",
                                variable.name = "Modality")
  all_res[[nam]] <- perf_long

}

all_res_list <- all_res
all_res <- do.call(what = "rbind", args = all_res_list)
all_res$Method <- ""
all_res[all_res$Modality == "Clinical", "Method"] <- "RF"
all_res[all_res$Modality == "CNV", "Method"] <- "RF"
all_res[all_res$Modality == "MiRNA", "Method"] <- "SVM"
all_res[all_res$Modality == "RNA", "Method"] <- "SVM"
all_res[all_res$Modality == "Mutation", "Method"] <- "SVM"
all_res[all_res$Modality == "Meta_layer", "Method"] <- "LASSO"
all_res$Method <- factor(all_res$Method)
all_res$Data <- factor(all_res$Data)
all_res$Modality <- factor(x = all_res$Modality,
                           levels = unique(all_res$Modality))

# Plot results
all_plots <- ggplot(data = all_res,
                    mapping = aes(x = Modality,
                                  y = value,
                                  colour = Modality)) +
  geom_boxplot() +
  ylab("Brier Score") +
  xlab("Method") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "bottom",
        legend.direction = "horizontal") +
  guides(color = guide_legend(nrow = 3)) +
  scale_x_discrete(limits = unique(all_res$Modality),
                   labels = c("RF", "RF", "SVM", "SVM", "LASSO")) +
  facet_wrap(~Data, ncol = 1, scales = "free_y")

print(all_plots)

ggsave(filename = file.path(result_dir, "boxplot.pdf"),
       plot = all_plots,
       width = 3, height = 4)

