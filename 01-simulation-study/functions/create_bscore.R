################################################
########## create Brier Score
###############################################

calculate_brier <- function(pred, target) {
  valid_indices <- !is.na(pred) # only valid values
  pred <- pred[valid_indices]
  target <- target[valid_indices]
  
  mean((pred - target)^2)
}


create_bs <- function(szenarien_namen, suffix, output_dir) {
  szenarien_namen <- szenarien_namen
  # for each scenario 
  for(szen_idx in 1:length(szenarien_namen)) {
    
    # scenario
    szenario_name <- szenarien_namen[szen_idx]
    daten_liste <-  mget(szenario_name, envir = .GlobalEnv)[[1]]
    
    rep <- length(daten_liste)
    # cataframe for brier-score
    brier_scores <- data.frame(methylierung = numeric(rep),
                               geneexpr = numeric(rep),
                               proteinexpr = numeric(rep),
                               meta_layer = numeric(rep))
    
  
    
    for (i in 1:rep) {
      data <- daten_liste[[i]]$result  
      target <- as.integer(data$disease == 1L) 
      
      brier_scores[i,] <- sapply(X = data[, c("methylierung", "geneexpr",
                                              "proteinexpr","meta_layer")],
                                 FUN = function (my_pred) {
                                   bs <- calculate_brier(target = target[complete.cases(my_pred)],
                                                         pred = my_pred[complete.cases(my_pred)])
                                   return(bs)
                                 })
      
    }
    
    # rename brier_scores
    sz_name <- paste0(gsub("pred", "bs", szenario_name), "_", suffix)
    assign(sz_name, brier_scores)
    
    ###########################################################
    # create output-file
    name_parts <- strsplit(sz_name, "_")[[1]]
    # Extract the scenario and NA components from the name
    scenario <- name_parts[1]  # z.B. "Sz1"
  
    if(scenario == "Sz2" | scenario == "Sz3"){
      effect_part = paste0(name_parts[2], "_", name_parts[3],"_", name_parts[4])
      scenario = file.path(scenario, effect_part)
    }
    
    # path
    path <- file.path(output_dir, scenario,  sz_name)
    # save as .rds-Datei
    saveRDS(get(sz_name), file = paste0(path, ".rds"))
    
    message(paste("brier score: ", sz_name, "is saved in" , paste0(path, ".rds")))
    
  }
  
}
