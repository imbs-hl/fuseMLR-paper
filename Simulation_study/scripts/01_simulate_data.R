
##################################################
#### Simulate multi-omics data with InterSIM 
##################################################

prop = c(0.50, 0.50)
rep = c(1:100)

# Scenario 1:
# Null model – no effect is present in any of the three omics modalities.

for(r in rep){
  set.seed(3811 + r)
  print(paste0("Working on ", "1Szenario_" ,r, "_0_0_0" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0, delta.expr = 0, delta.protein = 0,
                      p.DMP = 0, p.DEG = 0, p.DEP = 0,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0( "1Szenario_", r,  "_0_0_0.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# Scenario 2: One omics modality has no effect.
# Each sub-scenario lacks effect in one omics layer,
# while the other two layers simulate an effect.
# 20% of features are differentially expressed, and the effect size is 0.5.

#  no effect in methylation
for(r in rep){
  set.seed(159 + r)
  print(paste0("Working on " , "2Szenario_", r, "_0_20_20" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0, delta.expr = 0.5, delta.protein = 0.5,
                      p.DMP = 0, p.DEG = 0.2, p.DEP = 0.2,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("2Szenario_", r, "_0_20_20.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# no effect in gene expression
for(r in rep){
  set.seed(929 + r)
  print(paste0("Working on " , "2Szenario_", r,  "_20_0_20"))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.5, delta.expr = 0, delta.protein = 0.5,
                      p.DMP = 0.2, p.DEG = 0, p.DEP = 0.2,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("2Szenario_", r, "_20_0_20.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# *no effect in protein expression
for(r in rep){
  set.seed(389 + r )
  print(paste0("Working on " , "2Szenario_", r,  "_20_20_0" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.5, delta.expr = 0.5, delta.protein = 0,
                      p.DMP = 0.2, p.DEG = 0.2, p.DEP = 0,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("2Szenario_", r, "_20_20_0.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# Scenario 3: Only one omics modality has an effect.
# Each sub-scenario simulates effect in just one modality.
# 20% of features are differentially expressed, with effect size 0.5.

# * Methylation only
for(r in rep){
  set.seed(6704 + r)
  print(paste0("Working on " , "3Szenario_", r, "_20_0_0" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.5, delta.expr = 0, delta.protein = 0,
                      p.DMP = 0.2, p.DEG = 0, p.DEP = 0,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("3Szenario_", r, "_20_0_0.rds"))
  saveRDS(sim.D, file = pfad)
  
}


# Gene expression only
for(r in rep){
  set.seed(3675 + r)
  print(paste0("Working on " ,"3Szenario_", r, "_0_20_0" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0, delta.expr = 0.5, delta.protein = 0,
                      p.DMP = 0, p.DEG = 0.2, p.DEP = 0,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("3Szenario_", r, "_0_20_0.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# Protein expression only

for(r in rep){
  set.seed(7422 + r)
  print(paste0("Working on " , "3Szenario_", r, "_0_0_20" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0, delta.expr = 0, delta.protein = 0.5,
                      p.DMP = 0, p.DEG = 0, p.DEP = 0.2,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("3Szenario_", r, "_0_0_20.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# Scenario 4: Independent effect in all three omics modalities.
# Each omics modality has an effect; 20% of features are differentially expressed.
# Effect size is 0.5.


for(r in rep){
  set.seed(5621 + r)
  print(paste0("Working on ","4Szenario_",  r, "_20_20_20"))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.5, delta.expr = 0.5, delta.protein = 0.5,
                      p.DMP = 0.2, p.DEG = 0.2, p.DEP = 0.2,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  pfad <- file.path(out_sim_dir, paste0("4Szenario_", r,"_20_20_20",".rds"))
  saveRDS(sim.D, file = pfad)
}


# Scenario 5: Dependent effect across modalities.
# 20% of CpGs are differentially methylated.
# DE genes correspond to those CpGs, and DE proteins to those genes.
# Effect size is 0.5 for all layers.

for(r in rep){
  set.seed(7139 + r)
  print(paste0("Working on " , "5Szenario_",  r, "_20_NULL_NULL"))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.5, delta.expr = 0.5, delta.protein = 0.5,
                      p.DMP = 0.2, p.DEG = NULL, p.DEP = NULL,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)

  pfad <- file.path(out_sim_dir, paste0("5Szenario_", r,"_20_NULL_NULL",".rds"))
  saveRDS(sim.D, file = pfad)
}

