rm(list = ls())
source(file.path(simulation_dir, "init.R"))
##################################################
#### Prediction Modeling
#### blockForest
##################################################

# Read simulation data
read_sim_data(sim_data_early_file)

#' Function to fit and predict target variable using blocbForest (BF).
#'
#' @param data_name_list The list of simulated data.
#' @param output_dir Directory where to save results.
#' @param suffix Suffix indicating the method's name.
#' @param rep Number of runs.
#' @param seed_values Seed value.
#'
create_pred_bf <- function(data_name_list,
                           output_dir,
                           suffix,
                           rep,
                           seed_values) {
  
  for (sz in 1:length(data_name_list)) {
    # generate a list of random numbers for the seeds
    s <- seed_values[sz]
    set.seed(s)
    seeds <- sample(1000:9999, rep)
    # scenario 
    data_name <- data_name_list[sz]
    # create a list to store the results
    prediction_list <- list()
    # run repetitions
    for (i in 1:rep) {
      message(paste("working on scenario: ", sz, ", rep:" , i))
      current_seed <- seeds[i]
      set.seed(current_seed)
      # begin timing
      time_start = proc.time()
      data_list = get(data_name)[[i]]
      # create train and test data
      train_data <- data_list$training
      test_data <- data_list$testing
      # target variable to factor for classification
      train_labels <- as.factor(as.integer(train_data$disease) - 1 )
      true_labels <- as.factor(as.integer(test_data$disease) - 1 )
      train_data <- train_data[, setdiff(names(train_data), c("IDS", "disease")),
                               drop = FALSE]
      test_data <- test_data[, setdiff(names(test_data), c("IDS", "disease")),
                             drop = FALSE]
      # define modalities name for blockForest
      methyl_idx <- grep("cg\\d{8}", names(train_data))
      geneexpr_idx <- which(names(train_data) == "ACACA"):
        which(names(train_data) == "YWHAZ")
      protein_idx <- which(names(train_data) == "ACC1"):
        which(names(train_data) == "X14.3.3_zeta")
      blocks = list(methyl_idx = methyl_idx,
                    geneexpr_idx = geneexpr_idx, 
                    protein_idx = protein_idx)
      # train final model on training set
      final_blockForest_model <- blockfor(
        X = train_data,
        y = train_labels ,
        blocks = blocks, 
        probability = TRUE,
        num.trees = 5000, 
        block.method = "BlockForest"
      )
      # predict probabilities on test set
      test_preds <- predict(final_blockForest_model$forest, data = test_data,
                            block.method = "BlockForest")
      pred_values <- test_preds$predictions
      pred <- data.frame(pred_values,
                         target = true_labels)
      # finish timing 
      time_end = proc.time()
      train_pred_time = time_end - time_start
      # save result
      prediction_list[[i]] <- list(result = pred, 
                                   train_pred_time = train_pred_time)
    }
    # rename prediction_list
    sz_name <- paste0(data_name, "_pred_", suffix)
    assign(sz_name, prediction_list)
    # create output-file
    name_parts <- strsplit(sz_name, "_")[[1]]
    # extract the scenario and NA components from the name
    scenario <- name_parts[1] 
    if(scenario == "Sz2" | scenario == "Sz3"){
      effect_part = paste0(name_parts[2], "_", name_parts[3],"_", name_parts[4])
      scenario = file.path(scenario, effect_part)
    }
    # path
    path <- file.path(output_dir, scenario)
    # save as .rds-Datei 
    saveRDS(get(sz_name), file = paste0(path,"/", sz_name,".rds"))
    message(paste("Prediction: ", sz_name, "is saved in",
                  paste0(path, ".rds")))
  }
}


# create seed for 9 scenaries
seed_values <- c( 9631, 3886, 9715, 3724, 1396, 6883, 4368, 1863, 7552)

# read data from enviroment
data_name_list <- ls(pattern = "^Sz")

create_pred_bf(data_name_list = data_name_list,
               output_dir = result_blockForest_dir,
               suffix = "blockForest",
               rep = 100,
               seed_values = seed_values)
