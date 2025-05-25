##################################################
#### Performance estimation
#### Meta-Learner: Best Modality
##################################################


# read all predictions
read_sim_pred(src_dir = result_best_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# create brier score
create_bs(szenarien_namen = all_pred_namen, suffix = "best", 
          output_folder = result_best_dir)

# create auc
create_auc(szenarien_namen = all_pred_namen, suffix = "best", 
           output_folder = result_best_dir)