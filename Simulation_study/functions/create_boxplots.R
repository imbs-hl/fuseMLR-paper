###############################################
############ Brier Score Boxplot
#############################################


create_boxplots <- function(scenario_list, scenario_names,
                            output_dir, name) {
  
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
      
      # data for meta_layer 
      if ("meta_layer" %in% colnames(df)) {
        if (grepl("_wm", df_name)) {
          boxplot_data <- rbind(boxplot_data, data.frame(
            score = df$meta_layer,
            model = "Meta.WM"
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
    

    colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a" )
    
    
    
    
    model_order <- c("Meta.WM",  "Meta.Lasso",
                     "Early.RF", "Early.blockF")
    
    
    boxplot_data$model <- factor(boxplot_data$model, levels = model_order)
    
   
    
    # Boxplot 
    p <- ggplot(boxplot_data, aes(x = model, y = score, fill = model)) +
      geom_boxplot() +
      scale_fill_manual(values = colors) +
      theme_minimal() +
      # scale_y_continuous(limits = c(0, 0.4)) +
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
    ggsave(file.path(output_dir, name), plot = p,
           width = 8, height = 6)
    
    return(p)
  }
