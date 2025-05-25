
##################################################
#### Split Data to Train and Test (early integration)
##################################################


rep = c(1:100)
#rep = c(1:2)


# Scenario 1:
# Null model – no effect is present in any of the three omics modalities.

for(r in rep){
  print(paste0("Working on ", "1Scenario_" ,r, "_0_0_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/1Szenario_", r,  "_0_0_0.rds"))
  data_imp <- readRDS(file = import.pfad)

  # create data set 
  data <- data.frame(
    IDS = data_imp$clustering.assignment$subjects,
    data_imp$dat.methyl,
    data_imp$dat.expr,
    data_imp$dat.protein,
    disease = data_imp$clustering.assignment$cluster.id)
  
  rownames(data) <- NULL
  
  # # Split
  set.seed(129+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  
  # create training dataset
  training_dat  <- data[train_idx,]
  
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
 
  pfad <- file.path(out_sim_split_early_dir, paste0( "1Sz_split_", r,  "_0_0_0.rds"))
  saveRDS(entities, file = pfad) 
}

# Scenario 2: One omics modality has no effect.

##  no effect in methylation 
for(r in rep){
  print(paste0("Working on ", "2Scenario_" ,r, "_0_20_20" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/2Szenario_", r,  "_0_20_20.rds"))
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
  set.seed(1361+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0( "2Sz_split_", r,  "_0_20_20.rds"))
  saveRDS(entities, file = pfad) 
  
}

## no effect in gene expression
for(r in rep){
  print(paste0("Working on ", "2Scenario_", r,  "_20_0_20" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/2Szenario_", r,  "_20_0_20.rds"))
  data_imp <- readRDS(file = import.pfad)
  
  ## create data set  
  data <- data.frame(
    IDS = data_imp$clustering.assignment$subjects,
    data_imp$dat.methyl,
    data_imp$dat.expr,
    data_imp$dat.protein,
    disease = data_imp$clustering.assignment$cluster.id)
  
  rownames(data) <- NULL
  # Split
  set.seed(585+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0(  "2Sz_split_", r,  "_20_0_20.rds"))
  saveRDS(entities, file = pfad) 
  
}

# no effect in protein expression
for(r in rep){
  print(paste0("Working on ", "2Scenario_", r,  "_20_20_0" ))
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

# Scenario 3: Only one omics modality has an effect.
##  Methylation only

for(r in rep){
  print(paste0("Working on ", "3Scenario_", r,  "_20_0_0" ))
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


## Gene expression only

for(r in rep){
  print(paste0("Working on ", "3Scenario_", r,  "_0_20_0" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/3Szenario_", r,  "_0_20_0.rds"))
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
  set.seed(423+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0( "3Sz_split_", r,  "_0_20_0.rds"))
  saveRDS(entities, file = pfad) 
  
}

## Protein expression only

for(r in rep){
  print(paste0("Working on ", "3Scenario_", r,  "_0_0_20" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/3Szenario_", r,  "_0_0_20.rds"))
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
  set.seed(653+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(data), 0.667 * nrow(data))  # 70% for Training
  test_idx <- setdiff(1:nrow(data), train_idx)  # Test
  # create training dataset
  training_dat  <- data[train_idx,]
  # create test dataset
  test_dat  <- data[test_idx,]
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_early_dir, paste0( "3Sz_split_", r,  "_0_0_20.rds"))
  saveRDS(entities, file = pfad) 
  
}

# Scenario 4: Effect in all three omics modalities.

for(r in rep){
  print(paste0("Working on ", "4Scenario_", r,  "_20_20_20" ))
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


# Scenario 5: Dependent effect across modalities.

for(r in rep){
  print(paste0("Working on ", "5Scenario_", r,  "_20_NULL_NULL" ))
  import.pfad <- paste0(out_sim_dir, paste0("/5Szenario_", r,  "_20_NULL_NULL.rds"))
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
  
  pfad <- file.path(out_sim_split_early_dir, paste0("5Sz_split_", r,  "_20_NULL_NULL.rds"))
  saveRDS(entities, file = pfad) 
}

