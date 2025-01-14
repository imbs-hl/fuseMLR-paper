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
project_dir <- "~/projects/interconnect-publications/fuseMLR-paper"
dir.create(path = file.path(project_dir, "results"),
           recursive = TRUE,
           showWarnings = FALSE)
result_dir <- file.path(project_dir, "results")
data_dir <- file.path(project_dir, "data")

source(file.path(project_dir, "mylasso.R"))
source(file.path(project_dir, "mysvm.R"))

nams <- c("BLCA", "HNSC")
seeds <- c(422852, 342303)

for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  load(file.path(data_dir, sprintf("%s.RData", nams[nam])))
  # Crossvalidation folds for benchmarking
  target_df <- data.frame(ID = surdata$bcr_patient_barcode,
                          sex = clindata$gender_MALE_clinical)
  set.seed(seeds[nam])
  bench_folds <- caret::createFolds(y = target_df$sex, k = 10L)
  res_list <- lapply(X = 1L:10L, FUN = function(current_fold){
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
                    test_layer_id = "RNA",
                    test_data = testing_rna)
    
    # Create mutation layer.
    createTestLayer(testing = testing,
                    test_layer_id = "Mutation",
                    test_data = testing_mutation)
    
    
    # Train
    set.seed(5462)
    fusemlr(training = training,
            use_var_sel = TRUE)
    
    # Predict
    predictions <- predict(object = training, testing = testing)
    end_time <- proc.time()
    elapsed_time <- end_time - start_time
    pred_truth <- data.frame(cbind(Multiomics = nam,
                                   predictions$predicted_values,
                                   Truth = target_df_testing$sex,
                                   Runtime = elapsed_time["elapsed"]
    ))
    # Resume results
    fold_list <- list(training = training,
                      testing = testing,
                      pred_truth = pred_truth)
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
result_dir <- file.path(project_dir, "results")
all_res_list <- list()
for (nam in 1:length(nams)) {
  message(sprintf("Omics data: %s\n", nams[nam]))
  tmp_res <- NULL
  perf_list <- lapply(X = 1L:10L, FUN = function(current_fold){
    # Save the fold
    tmp_res <<- readRDS(
      file.path(result_dir,
                sprintf("%s_fold%02d.rds",
                        nams[nam],
                        current_fold))
    )
    tmp_res <- tmp_res$pred_truth
    brier_score_time <- sapply(3L:7L, function (layer) {
      bs <- mean(((1L - tmp_res[ , layer]) - tmp_res[ , 8L])^2L)
      return(bs)
    })
    brier_score_time <- c(brier_score_time, tmp_res$Runtime[1L] / 60L)
    names(brier_score_time) <- c(names(tmp_res)[3L:7L], "Runtime")
    return(c(brier_score_time))
  })
  perf_list <- as.data.table(do.call(what = "rbind", perf_list))
  # print(sprintf("Runtime %s: %s.\n", nams[nam], perf_list$Runtime))
  # perf_list$Runtime <- NULL
  perf_list$Data <- nams[nam]
  perf_long <- data.table::melt(data = perf_list,
                                id.vars = c("Data", "Runtime"),
                                variable.name = "Modality")
  all_res_list[[nam]] <- perf_long
}
all_res <- all_res_list
all_res <- do.call(what = "rbind", args = all_res)
all_res$Method <- ""
all_res[all_res$Modality == "CNV", "Method"] <- "RF"
all_res[all_res$Modality == "MiRNA", "Method"] <- "SVM"
all_res[all_res$Modality == "RNA", "Method"] <- "SVM"
all_res[all_res$Modality == "Mutation", "Method"] <- "RF"
all_res[all_res$Modality == "meta_layer", "Method"] <- "LASSO"
all_res$Method <- factor(x = all_res$Method, levels = c("RF", "SVM", "LASSO"))

# Plot results
all_res$Method <- factor(all_res$Method)
all_res$Data <- factor(all_res$Data)
all_res$Modality <- factor(x = all_res$Modality,
                           levels = unique(all_res$Modality))

# Plot results
all_plots <- ggplot(data = all_res,
                    mapping = aes(x = Modality,
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
                   labels = c("CNV.RF", "miRNA.SVM", "mRNA.SVM", "Mutation.RF", "Meta.LASSO")) +
  facet_wrap(~ Data, ncol = 1)

print(all_plots)

ggsave(filename = file.path(result_dir, "boxplotgender.pdf"),
       plot = all_plots,
       width = 2.75, height = 4)

# Mean runtimes
all_res[ , .(mean_time = mean(Runtime)), by = Data]

