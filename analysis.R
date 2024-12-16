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
<<<<<<< HEAD
project_dir <- "~/projects/interconnect-publications/fuseMLR-paper"
=======
project_dir <- "~/projects/interconnect-publications/fusemlr/TCGA"
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
dir.create(path = file.path(project_dir, "results"),
           recursive = TRUE,
           showWarnings = FALSE)
result_dir <- file.path(project_dir, "results")
data_dir <- file.path(project_dir, "data")

source(file.path(project_dir, "mylasso.R"))
source(file.path(project_dir, "mysvm.R"))

<<<<<<< HEAD
nams <- c("BLCA", "HNSC")
seeds <- c(42282, 42303)
=======
# nams <- c("COAD", "PAAD", "SARC")
nams <- c("BLCA", "HNSC")
seeds <- c(4282, 4233)
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19

for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  load(file.path(data_dir, sprintf("%s.RData", nams[nam])))
  # Crossvalidation folds for benchmarking
  target_df <- data.frame(ID = surdata$bcr_patient_barcode,
<<<<<<< HEAD
                          sex = clindata$gender_MALE_clinical)
  set.seed(seeds[nam])
  bench_folds <- caret::createFolds(y = target_df$sex, k = 10L)
=======
                          mutation = mutationdata$TP53_mutation)
  # Remove target from mutation modality
  mutationdata$TP53_mutation <- NULL
  # Start cross-validation for benchmarking
  set.seed(seeds[nam])
  bench_folds <- caret::createFolds(y = target_df$mutation, k = 10L)
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
  res_list <- lapply(X = 1L:10L, FUN = function(current_fold){
    message(sprintf("Omics data: %s: fold: %s\n", nams[nam], current_fold))
    testing_index <- bench_folds[[current_fold]]
    # ==============================================================================
    # Prepare data modalities
    # ==============================================================================
    # Testing
    target_df_testing <- target_df[testing_index, ]
<<<<<<< HEAD
    # testing_clin <- data.frame(cbind(ID = target_df$ID[testing_index]),
    #                            clindata[testing_index, ])
=======
    testing_clin <- data.frame(cbind(ID = target_df$ID[testing_index]),
                               clindata[testing_index, ])
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
    testing_cnv <- data.frame(cbind(ID = target_df$ID[testing_index]),
                              cnvdata[testing_index, ])
    testing_mirna <- data.frame(cbind(ID = target_df$ID[testing_index]),
                                mirnadata[testing_index, ])
    testing_rna <- data.frame(cbind(ID = target_df$ID[testing_index]),
                              rnadata[testing_index, ])
    testing_mutation <- data.frame(cbind(ID = target_df$ID[testing_index]),
                                   mutationdata[testing_index, ])
<<<<<<< HEAD
    
    # Training
    target_df_training <- target_df[-testing_index, ]
    # training_clin <- data.frame(cbind(ID = target_df$ID[- testing_index]),
    #                             clindata[ - testing_index, ])
=======

    # Training
    target_df_training <- target_df[-testing_index, ]
    training_clin <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                clindata[ - testing_index, ])
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
    training_cnv <- data.frame(cbind(ID = target_df$ID[ - testing_index]),
                               cnvdata[ - testing_index, ])
    training_mirna <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                 mirnadata[- testing_index, ])
    training_rna <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                               rnadata[- testing_index, ])
    training_mutation <- data.frame(cbind(ID = target_df$ID[- testing_index]),
                                    mutationdata[- testing_index, ])
<<<<<<< HEAD
    
=======

>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
    # ==========================================================================
    # fuseMLR
    # ==========================================================================
    #
    # Training
<<<<<<< HEAD
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
                     lrner_package = "ranger",
                     lrn_fct = "ranger",
                     param_train_list = list(probability = TRUE),
                     param_pred_list = list(),
                     na_action = "na.keep")
    
    # Create RNA layer.
    createTrainLayer(training = training,
                     train_layer_id = "RNA",
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
    
    # Create mutation layer.
    createTrainLayer(training = training,
                     train_layer_id = "Mutation",
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
    
    # Create meta-layer.
    createTrainMetaLayer(training = training,
                         meta_layer_id = "meta_layer",
                         lrner_package = NULL,
                         lrn_fct = "mylasso",
                         param_train_list = list(),
                         param_pred_list = list(na_rm = FALSE),
                         na_action = "na.keep")
    
    # Testing
    testing <- createTesting(id = "testing",
                               ind_col = "ID",
                               verbose = TRUE)
    
    
    # Create CNV layer.
    createTestLayer(testing = testing,
                     test_layer_id = "CNV",
                     test_data = testing_cnv)
    
    # Create MiRNA layer.
    createTestLayer(testing = testing,
                     test_layer_id = "MiRNA",
                     test_data = testing_mirna)
    
    # Create RNA layer.
    createTestLayer(testing = testing,
                     train_layer_id = "RNA",
                     train_data = testing_mirna)
    
    # Create mutation layer.
    createTestLayer(testing = testing,
                     train_layer_id = "Mutation",
                     train_data = testing_mirna)
    
  
    # Train
    set.seed(5462)
    fusemlr(training = training,
            use_var_sel = TRUE)
    
    # Predict
    predictions <- predict(object = training, testing = testing)
    pred_truth <- data.frame(cbind(Multiomics = nam,
                                   predictions$predicted_values,
                                   Truth = target_df_testing$sex
=======
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
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
    ))
    # Resume results
    fold_list <- list(training = training,
                      testing = testing,
                      pred_truth = pred_truth)
<<<<<<< HEAD
    # Resume results
    fold_list <- list(training = training,
                      testing = testing,
                      pred_truth = pred_truth)
=======

>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
    # Save the fold
    saveRDS(
      object = fold_list,
      file = file.path(result_dir,
<<<<<<< HEAD
                       sprintf("%s_50fold%02d.rds",
                               nams[nam],
                               current_fold))
    )
=======
                       sprintf("%s_fold%02d.rds",
                               nams[nam],
                               current_fold))
    )

>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
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
<<<<<<< HEAD
  # Crossvalidation folds for benchmarking
  # target_df <- data.frame(ID = surdata$bcr_patient_barcode,
  #                         mutation = mutationdata$TP53_mutation)
  # Remove target from mutation modality
  # mutationdata$TP53_mutation <- NULL
  # Start cross-validation for benchmarking
  set.seed(seeds[nam])
  # bench_folds <- caret::createFolds(y = target_df$sex, k = 10L)
=======
  # # Crossvalidation folds for benchmarking
  # target_df <- data.frame(ID = surdata$bcr_patient_barcode,
  #                         mutation = mutationdata$TP53_mutation)
  # # Remove target from mutation modality
  # mutationdata$TP53_mutation <- NULL
  # Start cross-validation for benchmarking
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
  perf_list <- lapply(X = 1L:10L, FUN = function(current_fold){
    # Save the fold
    tmp_res <- readRDS(
      file.path(result_dir,
<<<<<<< HEAD
                sprintf("%s_50fold%02d.rds",
=======
                sprintf("%s_fold%02d.rds",
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
                        nams[nam],
                        current_fold))
    )
    tmp_res <- tmp_res$pred_truth
<<<<<<< HEAD
    brier_score <- sapply(3:7, function (layer) {
=======
    brier_score <- sapply(3:8, function (layer) {
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
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
<<<<<<< HEAD
      tmp_brier1 <- mean((tmp_res[ , layer] - tmp_res[ , 8])^2)
      tmp_brier2 <- mean(((1- tmp_res[ , layer]) - tmp_res[ , 8])^2)
=======
      tmp_brier1 <- mean((tmp_res[ , layer] - tmp_res[ , 9])^2)
      tmp_brier2 <- mean((1- (tmp_res[ , layer]) - tmp_res[ , 9])^2)
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
      # return(c(clin_brier,
      #           cnv_brier,
      #           mirna_brier,
      #           rna_brier,
      #           mutation_brier,
      #           meta_brier))
<<<<<<< HEAD
      return(min(tmp_brier1, tmp_brier2))
    })
    names(brier_score) <- names(tmp_res)[3:7]
=======
      # ModelMetrics::brier(tmp_res[ , 8], tmp_res[ , layer])
      return(min(tmp_brier1, tmp_brier2))
    })
    names(brier_score) <- names(tmp_res)[3:8]
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
    return(brier_score)
  })
  perf_list <- as.data.table(do.call(what = "rbind", perf_list))
  perf_list$Data <- nams[nam]
  perf_long <- data.table::melt(data = perf_list,
                                id.vars = "Data",
                                variable.name = "Modality")
  all_res[[nam]] <- perf_long
<<<<<<< HEAD
  
}
all_res_list <- all_res
all_res <- do.call(what = "rbind", args = all_res)
all_res$Method <- ""
# all_res[all_res$Modality == "Clinical", "Method"] <- "RF"
all_res[all_res$Modality == "CNV", "Method"] <- "RF"
all_res[all_res$Modality == "MiRNA", "Method"] <- "SVM"
all_res[all_res$Modality == "RNA", "Method"] <- "SVM"
all_res[all_res$Modality == "Mutation", "Method"] <- "SVM"
all_res[all_res$Modality == "Meta_layer", "Method"] <- "LASSO"
all_res$Method <- factor(x = all_res$Method, levels = c("RF", "SVM", "LASSO"))

# Plot results
=======

}

all_res_list <- all_res
all_res <- do.call(what = "rbind", args = all_res_list)
>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
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
<<<<<<< HEAD
                                  y = log10(value),
                                  colour = Modality)) +
  geom_boxplot() +
  ylab("log10(BS)") +
  xlab("Modality and Method") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none",
        legend.direction = "horizontal") +
  guides(color = guide_legend(nrow = 3)) +
  scale_x_discrete(limits = unique(all_res$Modality),
                   labels = c("CNV.RF", "MiRNA.RF", "RNA.SVM", "Mutation.SVM", "Meta.LASSO")) +
  facet_wrap(~Data, ncol = 1)

print(all_plots)

ggsave(filename = file.path(result_dir, "boxplotgender.pdf"),
       plot = all_plots,
       width = 2.75, height = 4)
=======
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

>>>>>>> 5772a0dec5386d330dcb0eb60617c7ecba69bb19
