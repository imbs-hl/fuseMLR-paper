
# load packages
library(InterSIM)
library(fs)
library(here)
library(caret)
library(ranger)
library(Boruta)
library(dplyr)
library(fuseMLR)
library(UpSetR)
library(glmnet)
library(blockForest)


# define paths
data_dir <- here("data")
results_dir <- here("data_results")
functions_dir <- here("functions")
img_dir <- here("img")
out_sim_dir = file.path(data_dir, "InterSIM/")
out_sim_split_dir = file.path(data_dir, "InterSIM_split/")
out_sim_split_early_dir = file.path(data_dir, "InterSIM_split_early/")

result_best_dir = file.path(results_dir, "best/")
result_cobra_dir = file.path(results_dir, "cobra/")
result_wmean_dir = file.path(results_dir, "wmean/")
result_lasso_dir = file.path(results_dir, "lasso/")
result_mia_dir = file.path(results_dir, "mia/")
result_mean_dir = file.path(results_dir, "mean/")
result_rf_dir = file.path(results_dir, "rf/")
result_blockForest_dir = file.path(results_dir, "blockForest/")

# create dir
dir.create(file.path(data_dir, "InterSIM"), showWarnings = FALSE)
dir.create(file.path(data_dir, "InterSIM_split"), showWarnings = FALSE)
dir.create(file.path(data_dir, "InterSIM_split_early"), showWarnings = FALSE)
dir.create(file.path(results_dir, "best"), showWarnings = FALSE)
dir.create(file.path(results_dir, "cobra"), showWarnings = FALSE)
dir.create(file.path(results_dir, "wmean"), showWarnings = FALSE)
dir.create(file.path(results_dir, "lasso"), showWarnings = FALSE)
dir.create(file.path(results_dir, "mia"), showWarnings = FALSE)
dir.create(file.path(results_dir, "mean"), showWarnings = FALSE)
dir.create(file.path(results_dir, "rf"), showWarnings = FALSE)
dir.create(file.path(results_dir, "blockForest"), showWarnings = FALSE)


create_result_dirs <- function(result_dir) {
  dir.create(file.path(result_dir), showWarnings = FALSE)
  
  subdirs <- c(
    "Sz1",
    "Sz2",
    "Sz2/0_20_20",
    "Sz2/20_0_20",
    "Sz2/20_20_0",
    "Sz3",
    "Sz3/20_0_0",
    "Sz3/0_20_0",
    "Sz3/0_0_20",
    "Sz4",
    "Sz5"
  )
  
  for (subdir in subdirs) {
    dir.create(file.path(result_dir, subdir), showWarnings = FALSE, 
               recursive = TRUE)
  }
}

create_result_dirs(result_best_dir)
create_result_dirs(result_cobra_dir)
create_result_dirs(result_wmean_dir)
create_result_dirs(result_lasso_dir)
create_result_dirs(result_mia_dir)
create_result_dirs(result_mean_dir)
create_result_dirs(result_rf_dir)
create_result_dirs(result_blockForest_dir)

# load functions
source(file.path(functions_dir, "read_sim_data.R"))
source(file.path(functions_dir, "create_pred_fuseMLR.R"))
source(file.path(functions_dir, "create_bscore.R"))
source(file.path(functions_dir, "create_bscore_early.R"))
source(file.path(functions_dir, "create_auc.R"))
source(file.path(functions_dir, "create_auc_early.R"))
source(file.path(functions_dir, "read_sim_pred.R"))
source(file.path(functions_dir, "mylasso.R"))
source(file.path(functions_dir, "myInterSIM.R"))
source(file.path(functions_dir, "create_boxplots.R"))
source(file.path(functions_dir, "create_boxplots_nullmodell.R"))
source(file.path(functions_dir, "create_boxplots_auc.R"))
source(file.path(functions_dir, "create_boxplots_auc_nullmodell.R"))
source(file.path(functions_dir, "create_time.R"))
source(file.path(functions_dir, "create_boxplot_time.R"))


# list of .RDS datasets
sim_data_file <- list.files(path = out_sim_split_dir, pattern = "\\.rds$",
                            full.names = TRUE)
sim_data_early_file <- list.files(path = out_sim_split_early_dir, pattern = "\\.rds$",
                            full.names = TRUE)
