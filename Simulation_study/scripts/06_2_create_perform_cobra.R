##################################################
#### Performance estimation
#### Meta-Learner: COBRA
##################################################


# read all predictions
read_sim_pred(src_dir = result_cobra_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# create brier score
create_bs(szenarien_namen = all_pred_namen, suffix = "cobra_epsilon", 
          output_folder = result_cobra_dir)

# create auc
create_auc(szenarien_namen = all_pred_namen, suffix = "cobra_epsilon", 
           output_folder = result_cobra_dir)