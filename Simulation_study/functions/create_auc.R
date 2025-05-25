################################################
########## create AUC
###############################################

create_auc <- function(szenarien_namen, suffix, output_folder) {
  szenarien_namen <- szenarien_namen
  
  # for each scenario 
  for(szen_idx in 1:length(szenarien_namen)) {
    
    # scenario
    szenario_name <- szenarien_namen[szen_idx]
    daten_liste <-  mget(szenario_name, envir = .GlobalEnv)[[1]]
    
    rep <- length(daten_liste)
    
    # Dataframe for auc
    auc_wert <- data.frame(methylierung = numeric(rep),
                           geneexpr = numeric(rep),
                           proteinexpr = numeric(rep),
                           meta_layer = numeric(rep))
    
    for (i in 1:rep) {
      
      data <- daten_liste[[i]]$result
      target <- as.integer(data$disease == 1L)  # target (only for 0 and 1)
      

      auc_wert[i,] <- sapply(X = data[, c("methylierung", "geneexpr",
                                          "proteinexpr","meta_layer")],
                             FUN = function (my_pred) {
                               roc_obj <- pROC::roc(target[complete.cases(my_pred)],
                                                    my_pred[complete.cases(my_pred)])
                               

                               auc_value <- pROC::auc(roc_obj)
                               return(auc_value)
                             })
      
    }
    # rename scores
    sz_name <- paste0(gsub("pred", "auc", szenario_name), "_", suffix)
    assign(sz_name, auc_wert)
    
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
    path <- file.path(output_folder, scenario,  sz_name)
    # save as .rds-Datei 
    saveRDS(get(sz_name), file = paste0(path, ".rds"))
    
    message(paste("auc: ", sz_name, "is saved in" , paste0(path, ".rds")))
    
  }
  
  
}
