############################################
########  create predictions with fuseMLR
###########################################


create_pred_fuseMLR <- function (entities,
                                 ranger_param,
                                 meta_lrn_id,
                                 lrn_fct,
                                 meta_lrn_id_pram,
                                 meta_lrn_param_list,
                                 meta_l_na_rm,
                                 sd
){
  # convert 1,2 to 0,1
  # Save as factor, because classifivcation problem
  entities$training$target$disease <- as.factor(as.integer(entities$training$target$disease) - 1 )
  entities$testing$target$disease <- as.factor(as.integer(entities$testing$target$disease) - 1)
  
  # initiate training instance
  training <- Training$new(id = "training",
                           ind_col = "IDS",
                           target = "disease",
                           target_df = entities$training$target,
                           problem_type = "classification"
  )
  #print(training)
  # initiate layers
  tl_ge <- TrainLayer$new(id = "geneexpr",
                          training = training)
  tl_pr <- TrainLayer$new(id = "proteinexpr",
                          training = training)
  tl_me <- TrainLayer$new(id = "methylierung",
                          training = training)
  tl_meta <- TrainMetaLayer$new(id = "meta_layer",
                                training = training)
  
  # add tarin data
  train_data_ge <- TrainData$new(id = "geneexpr",
                                 train_layer = tl_ge,
                                 data_frame = entities$training$geneexpr)
  train_data_pr <- TrainData$new(id = "proteinexpr",
                                 train_layer = tl_pr,
                                 data_frame = entities$training$proteinexpr)
  train_data_me <- TrainData$new(id = "methylierung",
                                 train_layer = tl_me,
                                 data_frame = entities$training$methylation)
  # Learner Parameter
  lrner_ge <- Lrner$new(id = "ranger",
                        package = "ranger",
                        lrn_fct = "ranger",
                        param_train_list = ranger_param,
                        train_layer = tl_ge)
  lrner_pr <- Lrner$new(id = "ranger",
                        package = "ranger",
                        lrn_fct = "ranger",
                        param_train_list = ranger_param,
                        train_layer = tl_pr)
  lrner_me <- Lrner$new(id = "ranger",
                        package = "ranger",
                        lrn_fct = "ranger",
                        param_train_list = ranger_param,
                        train_layer = tl_me)
  
  lrner_meta <- Lrner$new(id = meta_lrn_id,
                          lrn_fct = lrn_fct,
                          param_train_list = meta_lrn_param_list,
                          na_action = meta_l_na_rm,
                          train_layer = tl_meta)
  
  #Train models with the selected variables.
  set.seed(sd)
  # 
  disease <- training$getTargetValues()$disease
  # Without varselection
  trained <- training$train(resampling_method = "caret::createFolds",
                            resampling_arg = list(y = disease,
                                                  k = 10L),
                            use_var_sel = FALSE
                            
  )
  
  ###########################################################################
  # Predicting 
  testing <- Testing$new(id = "testing", ind_col = "IDS")
  
  # Create new layers.
  nl_ge <- TestLayer$new(id = "geneexpr", testing = testing)
  nl_pr <- TestLayer$new(id = "proteinexpr", testing = testing)
  nl_me <- TestLayer$new(id = "methylierung", testing = testing)
  
  new_data_ge <- TestData$new(id = "geneexpr",
                              new_layer = nl_ge,
                              data_frame = entities$testing$geneexpr)
  new_data_pr <- TestData$new(id = "proteinexpr",
                              new_layer = nl_pr,
                              data_frame = entities$testing$proteinexpr)
  new_data_me <- TestData$new(id = "methylierung",
                              new_layer = nl_me,
                              data_frame = entities$testing$methylation)
  
  # predict with new data
  predictions <- training$predict(testing = testing)
  
  
  # prediction 
  pred_values <- predictions$predicted_values
  actual_pred <- merge(x = pred_values,
                       y = entities$testing$target,
                       by = "IDS",
                       all.y = TRUE)
  
  actual_pred
  
  
}
