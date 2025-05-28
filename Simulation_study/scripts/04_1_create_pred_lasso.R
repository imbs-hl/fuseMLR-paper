##################################################
#### Prediction Modeling
#### Meta-Learner: Lasso
##################################################

# read simulation data

read_sim_data(sim_data_file)
# function

create_pred_fuseMLR_lasso <- function(data_name_list, output_folder, suffix,
                                    rep, seed_values, ranger_param_prob) {
  
  # for each scenario
  for(sz in 1:length(data_name_list)) {
    
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
      
      # begin timing how long fuseMLR takes to execute.
      time_start = proc.time()
      # predictions
      result <- create_pred_fuseMLR(entities = get(data_name)[[i]],
                                    ranger_param = ranger_param_prob,
                                    meta_lrn_id = "lasso",
                                    lrn_fct = "mylasso",
                                    meta_lrn_param_list = list(nlambda = 25,
                                                               nfolds = 10), 
                                    meta_l_na_rm = "na.keep", 
                                    sd = current_seed
      )
      # finish timing the full fuseMLR execution.
      time_end = proc.time()
      train_pred_time = time_end - time_start
      # save result
      prediction_list[[i]] <- list(result =result, 
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
    path <- file.path(output_folder, scenario)
    # save as .rds-Datei 
    saveRDS(get(sz_name), file = paste0(path,"/", sz_name,".rds"))
    
    message(paste("prediction: ", sz_name, "is saved in" , paste0(path, ".rds")))
    
  }
  
}



# ranger parameter
ranger_param_prob <- list(probability = TRUE,
                          num.trees = 5000L,
                          classification = TRUE
)


# create seed 
seed_values <- c(379,826, 395, 193, 6300, 6210, 4430, 3389,789)

# read data from enviroment
data_name_list <- ls(pattern = "^Sz")

create_pred_fuseMLR_lasso(data_name_list = data_name_list, output_folder = result_lasso_dir,
                        suffix = "lasso", rep = 100, seed_values = seed_values,
                        ranger_param = ranger_param_prob)
