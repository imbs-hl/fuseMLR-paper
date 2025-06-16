##################################################
#### Performance estimation
#### Meta-Learner: Weighted Mean
##################################################
  

# read all predictions
read_sim_pred(src_dir = result_wmean_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# create brier score
create_bs(szenarien_namen = all_pred_namen, suffix = "wm", 
                 output_folder = result_wmean_dir)

# create auc
create_auc(szenarien_namen = all_pred_namen, suffix = "wm", 
                  output_folder = result_wmean_dir)


# create F1 score
create_f1(szenarien_namen = all_pred_namen, suffix = "wm", 
           output_folder = result_wmean_dir)






