###############################################
############ Extract Time 
#############################################

create_time <- function(scenario_names) {
  # for each scenario create prediction (45)
  for(sc_idx in 1:length(scenario_names)) {
    
    # Scenario
    scenario_name <- scenario_names[sc_idx]
    data_list <-  mget(scenario_name, envir = .GlobalEnv)[[1]]
    
    rep <- length(data_list)
    # Initialize a list to get the scores for each model 1:100 repetitions
    time_scores <- data.frame(time = numeric(rep))
    

    for (i in 1:rep) {
      data <- data_list[[i]]$train_pred_time  
      
      time_scores[i,] <- data["elapsed"] # time in seconds
    }
    assign(gsub("pred", "time", scenario_name), time_scores, envir = .GlobalEnv)
  }
}