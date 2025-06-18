################################################
########## create AUC
###############################################

#' Uses predicted probabilities and the observed values of the target variable 
#' to estimate the AUC.
#'
#' @param szenarien_namen Name of the scenario of interest. 
#' @param suffix Suffix indicating the method. 
#' @param output_dir Directory where to save results. 
#'
#' @return
#' @export
#'
#' @examples
create_auc <- function (szenarien_namen,
                        suffix,
                        output_dir) {
  szenarien_namen <- szenarien_namen
  
  # For each scenario 
  for(szen_idx in 1:length(szenarien_namen)) {
    # Scenario
    szenario_name <- szenarien_namen[szen_idx]
    daten_liste <-  mget(szenario_name, envir = .GlobalEnv)[[1]]
    
    rep <- length(daten_liste)
    
    # data.frame for auc
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
    # Rename scores
    sz_name <- paste0(gsub("pred", "auc", szenario_name), "_", suffix)
    assign(sz_name, auc_wert)
    
    ###########################################################
    # Create output-file
    name_parts <- strsplit(sz_name, "_")[[1]]
    # Extract the scenario and NA components from the name
    scenario <- name_parts[1] 

    if(scenario == "Sz2" | scenario == "Sz3"){
      effect_part = paste0(name_parts[2], "_", name_parts[3],"_", name_parts[4])
      scenario = file.path(scenario, effect_part)
    }
    
    path <- file.path(output_dir, scenario,  sz_name)
    saveRDS(get(sz_name), file = paste0(path, ".rds"))
    
    message(paste("auc: ", sz_name, "is saved in" , paste0(path, ".rds")))
    
  }
  
  
}
