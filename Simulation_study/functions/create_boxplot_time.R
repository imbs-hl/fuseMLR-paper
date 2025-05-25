###############################################
############ Time Boxplot
#############################################



create_boxplot_time <- function(scenario_list, scenario_names,
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
      if (grepl("_m$", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$time,
          model = "Meta.M"
        ))
      }
      
      # data for meta_layer 
      if (grepl("_wm", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$time,
          model = "Meta.WM"
        ))
      }

        if (grepl("_cobra_epsilon", df_name)) {
          boxplot_data <- rbind(boxplot_data, data.frame(
            score = df$time,
            model = "Meta.COBRA"
          ))
        }

        if (grepl("_mia", df_name)) {
          boxplot_data <- rbind(boxplot_data, data.frame(
            score = df$time,
            model = "Meta.RF"
          ))
        }
        if (grepl("_best", df_name)) {
          boxplot_data <- rbind(boxplot_data, data.frame(
            score = df$time,
            model = "Meta.Best"
          ))
        }
      if (grepl("_lasso", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$time,
          model = "Meta.Lasso"
        ))
      }
      if (grepl("_rf", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$time,
          model = "Early.RF"
        ))
      }
      if (grepl("_blockForest", df_name)) {
        boxplot_data <- rbind(boxplot_data, data.frame(
          score = df$time,
          model = "Early.blockF"
        ))
      }
      
    }
    
 
    colors <- c( "#e7298a", "#66a61e", 
                "#e6ab02","#a6cee3", "#b2df8a", "#fc9272", "#b3b3b3", "#e78ac3" )
   
    model_order <- c("Meta.M",
                     "Meta.WM", "Meta.COBRA",  "Meta.RF", "Meta.Best", "Meta.Lasso",
                     "Early.RF", "Early.blockF")
    
    boxplot_data$model <- factor(boxplot_data$model, levels = model_order)
    
    # Boxplot
    p <- ggplot(boxplot_data, aes(x = model, y = score, fill = model)) +
      geom_boxplot() +
      scale_fill_manual(values = colors) +
      theme_minimal() +
      scale_y_continuous(limits = c(0, 70)) +
      theme(
        #axis.text.x = element_text(angle = 45, hjust = 1),
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
        #title = "Boxplot der Kategorien",
        y = "Time in seconds",
        x = "Learner"
      )
    
    ggsave(file.path(output_folder, name), plot = p,
           width = 8, height = 6)
    return(p)
  }
