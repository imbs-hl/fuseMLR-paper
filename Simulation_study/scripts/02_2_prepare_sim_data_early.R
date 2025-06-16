
##################################################
#### Split Data to Train and Test (early integration)
##################################################


rep = c(1:100)

# Scenario : One omics modality has no effect.

# no effect in protein expression
for(r in rep){
  print(paste0("Working on ", "2 scenario_", r,  "_20_20_0" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/2Szenario_", r,  "_20_20_0.rds"))
  data_imp <- readRDS(file = import.pfad)
  # # create data set 
  data <- data.frame(
    IDS = data_imp$clustering.assignment$subjects,
    data_imp$dat.methyl,
    data_imp$dat.expr,
    data_imp$dat.protein,
    disease = data_imp$clustering.assignment$cluster.id)
  
  rownames(data) <- NULL
  # Split
  set.seed(23+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0( "2Sz_split_", r,  "_20_20_0.rds"))
  saveRDS(entities, file = pfad) 
  
}

# Scenario: Only one omics modality has an effect.
##  Methylation only

for(r in rep){
  print(paste0("Working on ", "3 scenario_", r,  "_20_0_0" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/3Szenario_", r,  "_20_0_0.rds"))
  data_imp <- readRDS(file = import.pfad)
  # create data set 
  data <- data.frame(
    IDS = data_imp$clustering.assignment$subjects,
    data_imp$dat.methyl,
    data_imp$dat.expr,
    data_imp$dat.protein,
    disease = data_imp$clustering.assignment$cluster.id)
  
  rownames(data) <- NULL
  # Split
  set.seed(873+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0( "3Sz_split_", r,  "_20_0_0.rds"))
  saveRDS(entities, file = pfad) 
  
}


# Scenario: Independent effect in all three omics modalities.

for(r in rep){
  print(paste0("Working on ", "4 scenario_", r,  "_20_20_20" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/4Szenario_", r,  "_20_20_20.rds"))
  data_imp <- readRDS(file = import.pfad)
  # create data set 
  data <- data.frame(
    IDS = data_imp$clustering.assignment$subjects,
    data_imp$dat.methyl,
    data_imp$dat.expr,
    data_imp$dat.protein,
    disease = data_imp$clustering.assignment$cluster.id)
  
  rownames(data) <- NULL
  # Split
  set.seed(119+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0( "4Sz_split_", r,  "_20_20_20.rds"))
  saveRDS(entities, file = pfad) 
}


