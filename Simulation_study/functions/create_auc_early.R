################################################
########## create AUC
###############################################

create_auc_early <- function(szenarien_namen, suffix, output_dir) {
  szenarien_namen <- szenarien_namen
  
  # for each scenario 
  for(szen_idx in 1:length(szenarien_namen)) {
    
    # scenario
    szenario_name <- szenarien_namen[szen_idx]
    daten_liste <-  mget(szenario_name, envir = .GlobalEnv)[[1]]
    
    rep <- length(daten_liste)
    
    # Dataframe for auc
    auc_value <- data.frame(meta_layer = numeric(rep))
    
    for (i in 1:rep) {
      
      data <- daten_liste[[i]]$result
      target <- as.integer(data$target == 1L)  # target (only for 0 and 1)
      names(data)[names(data) == "X1"] <- "meta_layer"
      my_pred <- data$meta_layer
      
      roc_obj <- pROC::roc(target[complete.cases(my_pred)],
                           my_pred[complete.cases(my_pred)])
      auc_value[i, "meta_layer"] <- pROC::auc(roc_obj)
                               
      
    }
    # rename scores
    sz_name <- paste0(gsub("pred", "auc", szenario_name), "_", suffix)
    assign(sz_name, auc_value)
    
    ###########################################################
    # create output-file
    name_parts <- strsplit(sz_name, "_")[[1]]
    # Extract the scenario and NA components from the name
    scenario <- name_parts[1] 

    if(scenario == "Sz2" | scenario == "Sz3"){
      effect_part = paste0(name_parts[2], "_", name_parts[3],"_", name_parts[4])
      scenario = file.path(scenario, effect_part)
    }
    
    # path
    path <- file.path(output_dir, scenario,  sz_name)
    # save as .rds-Datei 
    saveRDS(get(sz_name), file = paste0(path, ".rds"))
    
    message(paste("auc: ", sz_name, "is saved in" , paste0(path, ".rds")))
    
  }
  
  
}
