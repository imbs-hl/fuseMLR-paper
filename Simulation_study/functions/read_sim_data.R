#############################################
############# read Data
############################################

read_sim_data <- function(datei_pfade) {
  # Extract the base names (file names without the path)
  datei_namen <- basename(datei_pfade)
  
  
  # Define the list of patterns (these are the prefixes/group identifiers)
  muster <- c(
    "1Sz_split_([0-9]+)",
    "2Sz_split_([0-9]+)_0_20_20",
    "2Sz_split_([0-9]+)_20_20_0",
    "2Sz_split_([0-9]+)_20_0_20",
    "3Sz_split_([0-9]+)_0_0_20",
    "3Sz_split_([0-9]+)_20_0_0",
    "3Sz_split_([0-9]+)_0_20_0",
    "4Sz_split_([0-9]+)_20_20_20",
    "5Sz_split_([0-9]+)_20_NULL_NULL"
  )
  
  
  # Loop through each pattern to group and read matching files
  for (m in muster) {
    # Select files that match the current pattern
    passende_dateien <- datei_pfade[grepl(m, datei_namen)]
    
    nummern <- as.numeric(gsub(".*_split_([0-9]+)_.*", "\\1", passende_dateien))
    
    # Extract numeric identifiers from filenames for sorting
    passende_dateien <- passende_dateien[order(nummern)]
    gruppierte_listen <- lapply(passende_dateien, readRDS)
    
    basenamen <- gsub("(.*)(_split_[0-9]+)(.*).rds", "\\1\\3", basename(passende_dateien))
    basename <- unique(basenamen)
    # Sz1
    if (grepl("1Sz_0_0_0", basename)) {
      basename <- "Sz1_0_0_0"
    }
    #  Sz2
    if (grepl("2Sz_0_20_20", basename)) {
      basename <- "Sz2_0_20_20"
    }
    if (grepl("2Sz_20_0_20", basename)) {
      basename <- "Sz2_20_0_20"
    }
    if (grepl("2Sz_20_20_0", basename)) {
      basename <- "Sz2_20_20_0"
    }
    #Sz3
    if (grepl("3Sz_0_0_20", basename)) {
      basename <- "Sz3_0_0_20"
    }
    if (grepl("3Sz_0_20_0", basename)) {
      basename <- "Sz3_0_20_0"
    }
    if (grepl("3Sz_20_0_0", basename)) {
      basename <- "Sz3_20_0_0"
    }
    #Sz4
    if (grepl("4Sz_20_20_20", basename)) {
      basename <- "Sz4_20_20_20"
    }
    #Sz5
    if (grepl("5Sz_20_NULL_NULL", basename)) {
      basename <- "Sz5_20_NULL_NULL"
    }
    
    
    assign(basename, gruppierte_listen, envir = .GlobalEnv)
    message("Loaded and assigned to global environment: ", basename)
  }
  
}