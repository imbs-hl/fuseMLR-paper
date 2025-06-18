#' Calculate Brier score given observed and estimated probabilties.
#'
#' @param pred Predicted probabilities.
#' @param target Oberseved values.
#'
calculate_brier <- function(pred, target) {
  valid_indices <- !is.na(pred) # only valid values
  pred <- pred[valid_indices]
  target <- target[valid_indices]
  mean((pred - target)^2)
}


#' Uses predicted probabilities and the observed values of the target variable 
#' to estimate the Brier score for late integration approaches.
#'
#' @param szenarien_namen Name of the scenario of interest. 
#' @param suffix Suffix indicating the method. 
#' @param output_dir Directory where to save results. 
#'
create_bs_early <- function(szenarien_namen,
                            suffix,
                            output_dir) {
  szenarien_namen <- szenarien_namen
  # For each scenario 
  for(szen_idx in 1:length(szenarien_namen)) {
    
    # Scenario
    szenario_name <- szenarien_namen[szen_idx]
    daten_liste <-  mget(szenario_name, envir = .GlobalEnv)[[1]]
    
    rep <- length(daten_liste)
    # data.frame for brier-score
    brier_scores <- data.frame(meta_layer = numeric(rep))
    
    for (i in 1:rep) {
      data <- daten_liste[[i]]$result  
      target <- as.integer(data$target == 1L) 
      names(data)[names(data) == "X1"] <- "meta_layer"
      my_pred <- data$meta_layer
      bs <- calculate_brier(
        target = target[complete.cases(my_pred)],
        pred   = my_pred[complete.cases(my_pred)])
      brier_scores[i, "meta_layer"] <- bs
    }
    # Rename brier_scores
    sz_name <- paste0(gsub("pred", "bs", szenario_name), "_", suffix)
    assign(sz_name, brier_scores)
    
    ###########################################################
    # Create output-file
    name_parts <- strsplit(sz_name, "_")[[1]]
    # Extract the scenario and NA components from the name
    scenario <- name_parts[1] 
    if(scenario == "Sz2" | scenario == "Sz3"){
      effect_part = paste0(name_parts[2], "_", name_parts[3],"_",
                           name_parts[4])
      scenario = file.path(scenario, effect_part)
    }
    
    # Path
    path <- file.path(output_dir, scenario,  sz_name)
    # Save as .rds-Datei
    saveRDS(get(sz_name), file = paste0(path, ".rds"))
    message(paste("brier score: ", sz_name, "is saved in",
                  paste0(path, ".rds")))
  }
}
