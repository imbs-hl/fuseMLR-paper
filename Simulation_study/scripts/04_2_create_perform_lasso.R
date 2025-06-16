##################################################
#### Performance estimation
#### Meta-Learner: Lasso
##################################################


# Read all predictions
read_sim_pred(src_dir = result_lasso_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# Create brier score
create_bs(szenarien_namen = all_pred_namen, suffix = "lasso", 
          output_folder = result_lasso_dir)

# Create auc
create_auc(szenarien_namen = all_pred_namen, suffix = "lasso", 
           output_folder = result_lasso_dir)

# Create F1 score
create_f1(szenarien_namen = all_pred_namen, suffix = "lasso", 
           output_folder = result_lasso_dir)