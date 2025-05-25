###############################################
############ Brier-Score Boxplot (nullmodel)
############ 
#############################################


create_boxplot_nullm <- function(scenario_list, scenario_names,
                                 output_folder, name) {
  
  idx_sc1 <- scenario_names
  dataframes_list <- scenario_list[idx_sc1]
  
  # create a dataframe
  boxplot_data <- data.frame(
    score = numeric(),
    model = character(),
    stringsAsFactors = FALSE
  )
  
  for (i in seq_along(dataframes_list)) {
    df <- dataframes_list[[i]]
    df_name <- names(dataframes_list)[i]
    
    # data for _m: methylierung, geneexpr, proteinexpr, MW
    if (grepl("_m", df_name)) {
      boxplot_data <- rbind(boxplot_data, data.frame(
        score = df$methylierung,
        model = "Methyl.RF"
      ))
      boxplot_data <- rbind(boxplot_data, data.frame(
        score = df$geneexpr,
        model = "Gene.RF"
      ))
      boxplot_data <- rbind(boxplot_data, data.frame(
        score = df$proteinexpr,
        model = "Prot.RF"
      ))
      boxplot_data <- rbind(boxplot_data, data.frame(
        score = df$meta_layer,
        model = "Meta.M"
      ))
    }
    
    # data for meta_layer 
    if ("meta_layer" %in% colnames(df)) {
      if (grepl("_wm", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Meta.WM"
        ))
      }
      
      if (grepl("_cobra_epsilon", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Meta.COBRA"
        ))
      }
      
      if (grepl("_mia", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Meta.RF"
        ))
      }
      if (grepl("_best", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Meta.Best"
        ))
      }
      
      if (grepl("_lasso", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Meta.Lasso"
        ))
      }
      if (grepl("_rf", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Early.RF"
        ))
      }
      if (grepl("_blockForest", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$meta_layer,
          model = "Early.blockF"
        ))
      }
      
    }
  }
  
  
  colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", 
              "#e6ab02","#a6cee3", "#b2df8a", "#fc9272", "#b3b3b3", "#e78ac3" )
  
  
  
  
  model_order <- c("Methyl.RF", "Gene.RF", "Prot.RF", "Meta.M",
                   "Meta.WM", "Meta.COBRA",  "Meta.RF", "Meta.Best", "Meta.Lasso",
                   "Early.RF", "Early.blockF")
  
  
  boxplot_data$model <- factor(boxplot_data$model, levels = model_order)
    
    
    # create Boxplot
    p <- ggplot(boxplot_data, aes(x = model, y = score, fill = model)) +
      geom_boxplot() +
      geom_hline(yintercept = 0.25, color = "red", linetype = "dashed") +
      scale_fill_manual(values = colors) +
      theme_minimal() +
      scale_y_continuous(limits = c(0, 0.4)) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.text.y = element_text(size = 12), 
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        legend.position = "none",
        axis.ticks.x = element_line(),
        axis.ticks.y = element_line(),
        axis.line = element_line()
        
      ) +
      labs(
        y = "BS",
        x = "Modality and learner"
      )
    ggsave(file.path(output_folder, name), plot = p,
           width = 8, height = 6)
    
    return(p)
  }
