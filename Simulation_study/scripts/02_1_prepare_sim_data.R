
##################################################
#### Split Data to Train and Test (late integration)
##################################################

rep = c(1:100)


# Scenario 1:
# Null model – no effect is present in any of the three omics modalities.

for(r in rep){
  print(paste0("Working on ", "1Scenario_" ,r, "_0_0_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/1Szenario_", r,  "_0_0_0.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(129+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                      testing= test_dat)
 
  pfad <- file.path(out_sim_split_dir, paste0( "1Sz_split_", r,  "_0_0_0.rds"))
  saveRDS(entities, file = pfad) 
}

# Scenario 2: One omics modality has no effect.

##  no effect in methylation

for(r in rep){
  print(paste0("Working on ", "2Scenario_" ,r, "_0_20_20" ))
  import.pfad <- paste0(out_sim_dir, paste0("/2Szenario_", r,  "_0_20_20.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(1361+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("2Sz_split_", r,  "_0_20_20.rds"))
  saveRDS(entities, file = pfad) 
  
}

## no effect in gene expression

for(r in rep){
  print(paste0("Working on ", "2Scenario_", r,  "_20_0_20" ))
  import.pfad <- paste0(out_sim_dir, paste0( "/2Szenario_", r,  "_20_0_20.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(585+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("2Sz_split_", r,  "_20_0_20.rds"))
  saveRDS(entities, file = pfad) 
  
}

# no effect in protein expression

for(r in rep){
  print(paste0("Working on ", "2Scenario_", r,  "_20_20_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/2Szenario_", r,  "_20_20_0.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(23+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("2Sz_split_", r,  "_20_20_0.rds"))
  saveRDS(entities, file = pfad) 
  
}

# Scenario 3: Only one omics modality has an effect.
##  Methylation only

for(r in rep){
  print(paste0("Working on ", "3Scenario_", r,  "_20_0_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/3Szenario_", r,  "_20_0_0.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(873+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("3Sz_split_", r,  "_20_0_0.rds"))
  saveRDS(entities, file = pfad) 
  
}


## Gene expression only

for(r in rep){
  print(paste0("Working on ", "3Scenario_", r,  "_0_20_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/3Szenario_", r,  "_0_20_0.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(423+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("3Sz_split_", r,  "_0_20_0.rds"))
  saveRDS(entities, file = pfad) 
  
}

## Protein expression only

for(r in rep){
  print(paste0("Working on ", "3Scenario_", r,  "_0_0_20" ))
  import.pfad <- paste0(out_sim_dir, paste0("/3Szenario_", r,  "_0_0_20.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(653+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("3Sz_split_", r,  "_0_0_20.rds"))
  saveRDS(entities, file = pfad) 
  
}

# Scenario 4: Effect in all three omics modalities.

for(r in rep){
  print(paste0("Working on ", "4Scenario_", r,  "_20_20_20" ))
  import.pfad <- paste0(out_sim_dir, paste0("/4Szenario_", r,  "_20_20_20.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(119+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("4Sz_split_", r,  "_20_20_20.rds"))
  saveRDS(entities, file = pfad) 
}


# Scenario 5: Dependent effect across modalities.

for(r in rep){
  print(paste0("Working on ", "5Scenario_", r,  "_20_NULL_NULL" ))
  import.pfad <- paste0(out_sim_dir, paste0("/5Szenario_", r,  "_20_NULL_NULL.rds"))
  data_imp <- readRDS(file = import.pfad)
  # data.frame with ids und y
  target_df <- data_imp$clustering.assignment
  names(target_df) <- c("IDS", "disease")
  data  <- list("methylation" = data.frame(data_imp$dat.methyl,
                                           IDS = row.names(data_imp$dat.methyl)),
                "geneexpr" = data.frame(data_imp$dat.expr,
                                        IDS = row.names(data_imp$dat.expr)),
                "proteinexpr" = data.frame(data_imp$dat.protein,
                                           IDS = row.names(data_imp$dat.protein)),
                "target" = target_df)
  # Split
  set.seed(23+r)
  # create random indicies for Training and Test
  train_idx <- sample(1:nrow(target_df), 0.667 * nrow(target_df))  # 70% for Training
  test_idx <- setdiff(1:nrow(target_df), train_idx)  # Test
  
  # create training dataset
  training_dat  <- list("methylation" = data[["methylation"]][train_idx,],
                        "geneexpr" = data[["geneexpr"]][train_idx,],
                        "proteinexpr"=  data[["proteinexpr"]][train_idx,],
                        "target" = target_df[train_idx,])
  
  # create test dataset
  test_dat  <- list("methylation" = data[["methylation"]][test_idx,],
                    "geneexpr" =  data[["geneexpr"]][test_idx,],
                    "proteinexpr"= data[["proteinexpr"]][test_idx,],
                    "target" = target_df[test_idx,])
  
  entities <- list(training= training_dat,
                   testing= test_dat)
  
  pfad <- file.path(out_sim_split_dir, paste0("5Sz_split_", r,  "_20_NULL_NULL.rds"))
  saveRDS(entities, file = pfad) 
}

