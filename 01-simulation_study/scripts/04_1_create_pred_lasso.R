rm(list = ls())
source("init.R")
##################################################
#### Prediction Modeling
#### Meta-Learner: Lasso
##################################################

# read simulation data

read_sim_data(sim_data_file)
# function
#' Function to fit and predict target variable using Lasso as meta-learner.
#'
#' @param data_name_list The list of simulated data.
#' @param output_dir Directory where to save results.
#' @param suffix Suffix indicating the method's name.
#' @param rep Number of runs.
#' @param seed_values Seed value.
#'
create_pred_fuseMLR_lasso <- function(data_name_list, 
                                      output_dir, 
                                      suffix,
                                      rep, 
                                      seed_values, 
                                      ranger_param_prob) {
  # For each scenario
  for(sz in 1:length(data_name_list)) {
    # Generate a list of random numbers for the seeds
    s <- seed_values[sz]
    set.seed(s)
    seeds <- sample(1000:9999, rep)
    # Scenario 
    data_name <- data_name_list[sz]
    # Create a list to store the results
    prediction_list <- list()
    # Run repetitions
    for (i in 1:rep) {
      message(paste("working on scenario: ", sz, ", rep:" , i))
      current_seed <- seeds[i]
      # Begin timing how long fuseMLR takes to execute.
      time_start = proc.time()
      # Predictions
      result <- create_pred_fuseMLR(entities = get(data_name)[[i]],
                                    ranger_param = ranger_param_prob,
                                    meta_lrn_id = "lasso",
                                    lrn_fct = "mylasso",
                                    meta_lrn_param_list = list(nlambda = 25,
                                                               nfolds = 10), 
                                    meta_l_na_rm = "na.keep", 
                                    sd = current_seed
      )
      # Finish timing the full fuseMLR execution.
      time_end = proc.time()
      train_pred_time = time_end - time_start
      # Save result
      prediction_list[[i]] <- list(result =result, 
                                   train_pred_time = train_pred_time)
      
    }
    # Rename prediction_list
    sz_name <- paste0(data_name, "_pred_", suffix)
    assign(sz_name, prediction_list)
    # Create output-file
    name_parts <- strsplit(sz_name, "_")[[1]]
    # Extract the scenario and NA components from the name
    scenario <- name_parts[1]  
    if(scenario == "Sz2" | scenario == "Sz3"){
      effect_part = paste0(name_parts[2], "_", name_parts[3],"_", name_parts[4])
      scenario = file.path(scenario, effect_part)
    }
    # Path
    path <- file.path(output_dir, scenario)
    # Save as .rds-Datei 
    saveRDS(get(sz_name), file = paste0(path,"/", sz_name,".rds"))
    message(paste("prediction: ", sz_name, "is saved in" , paste0(path, ".rds")))
  }
}

# ranger parameter
ranger_param_prob <- list(probability = TRUE,
                          num.trees = 5000L,
                          classification = TRUE
)


# Create seed 
seed_values <- c(379,826, 395, 193, 6300, 6210, 4430, 3389,789)

# Read data from enviroment
data_name_list <- ls(pattern = "^Sz")

create_pred_fuseMLR_lasso(data_name_list = data_name_list,
                          output_dir = result_lasso_dir,
                          suffix = "lasso",
                          rep = 100,
                          seed_values = seed_values,
                          ranger_param = ranger_param_prob)
