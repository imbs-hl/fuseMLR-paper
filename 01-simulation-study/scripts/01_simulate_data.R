
##################################################
#### Simulate multi-omics data with InterSIM 
##################################################

prop = c(0.50, 0.50)
rep = c(1:100)

# Scenario : Only one omics modality has effects.
# scenario simulates effect in just one modality.
# 20% of features are differentially expressed, with effect size 0.5.

#  Methylation only
for(r in rep){
  set.seed(6704 + r)
  print(paste0("Working on " , "3scenario", r, "_20_0_0" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.1, delta.expr = 0, delta.protein = 0,
                      p.DMP = 0.2, p.DEG = 0, p.DEP = 0,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("3scenario", r, "_20_0_0.rds"))
  saveRDS(sim.D, file = pfad)
  
}

# Scenario: Two omics-modalities have effects.
# scenario lacks effect in one omics modality (protein expression),
# while the other two modalities contain effects.
# 20% of features are differentially expressed, and the effect size is 0.5.

# no effect in protein expression
for(r in rep){
  set.seed(389 + r )
  print(paste0("Working on " , "2scenario", r,  "_20_20_0" ))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.1, delta.expr = 0.1, delta.protein = 0,
                      p.DMP = 0.2, p.DEG = 0.2, p.DEP = 0,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  
  pfad <- file.path(out_sim_dir, paste0("2scenario", r, "_20_20_0.rds"))
  saveRDS(sim.D, file = pfad)
  
}


# Scenario : Independent effects in all three omics modalities.
# Each omics modality has effects; 20% of features are differentially expressed.
# Effect size is 0.5.


for(r in rep){
  set.seed(5621 + r)
  print(paste0("Working on ","4scenario",  r, "_20_20_20"))
  sim.D <- myInterSIM(n.sample = 300, cluster.sample.prop = prop,
                      delta.methyl = 0.1, delta.expr = 0.1, delta.protein = 0.1,
                      p.DMP = 0.2, p.DEG = 0.2, p.DEP = 0.2,
                      sigma.methyl = NULL, sigma.expr = NULL, sigma.protein = NULL,
                      cor.methyl.expr = NULL, cor.expr.protein = NULL,
                      do.plot=FALSE, sample.cluster=TRUE, feature.cluster=TRUE)
  pfad <- file.path(out_sim_dir, paste0("4scenario", r,"_20_20_20",".rds"))
  saveRDS(sim.D, file = pfad)
}


