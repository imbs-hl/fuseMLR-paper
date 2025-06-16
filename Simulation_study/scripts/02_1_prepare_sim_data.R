
##################################################
#### Split Data to Train and Test (late integration)
##################################################

rep = c(1:100)


# Scenario: One omics modality has no effect.

# no effect in protein expression

for(r in rep){
  print(paste0("Working on ", "2scenario", r,  "_20_20_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/2scenario", r,  "_20_20_0.rds"))
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

# Scenario : Only one omics modality has effects.
##  Methylation only

for(r in rep){
  print(paste0("Working on ", "3scenario", r,  "_20_0_0" ))
  import.pfad <- paste0(out_sim_dir, paste0("/3scenario", r,  "_20_0_0.rds"))
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



# Scenario: Independent effects in all three omics modalities.

for(r in rep){
  print(paste0("Working on ", "4scenario", r,  "_20_20_20" ))
  import.pfad <- paste0(out_sim_dir, paste0("/4scenario", r,  "_20_20_20.rds"))
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



