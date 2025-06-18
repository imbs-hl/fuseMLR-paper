###########################################################
############# read predictions
##########################################################


read_sim_pred <- function(src_dir, pattern_imp, pattern_exp) {
  # find all files in the source directory
  files <- list.files(src_dir, recursive = TRUE, full.names = TRUE, 
                      pattern = pattern_imp, ignore.case = TRUE)
  
  # iterate through each file
  for (file in files) {
    # read the file
    data <- readRDS(file)
    
    # Split the file path
    path_parts <- strsplit(file, split = "/|\\\\")[[1]]
    
    # Identify the scenario and create a new name 
    
    # Scenario Sz2
    if (grepl("Sz2", file)) {
      sz <- "Sz2"
      subfolder <- path_parts[length(path_parts) - 1]  
      new_name <- paste0(sz, "_", subfolder, "_", pattern_exp)
    }
    
    # Scenario Sz3
    if (grepl("Sz3", file)) {
      sz <- "Sz3"
      subfolder <- path_parts[length(path_parts) - 1]  
      new_name <- paste0(sz, "_", subfolder, "_", pattern_exp)
    }
    
    # Scenario Sz4
    if (grepl("Sz4", file)) {
      sz <- "Sz4"
      new_name <- paste0("Sz4_20_20_20_", pattern_exp)
    }
    
    # Assign the data to the global environment using the new name
    assign(new_name, data, envir = .GlobalEnv)
    message("Loaded and assigned to global environment: ", new_name)
    
  }
}