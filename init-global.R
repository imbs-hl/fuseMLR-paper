# Ensure you have installed the following packages.

# install.packages("OpenML")
# install.packages("farff")
# install.packages("readr")
# install.packages("fuseMLR")
# install.packages("ranger")
# install.packages("glmnet")
# install.packages("e1071")
# install.packages("data.table")
# install.packages("ggplot2")
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("mirbase.db")
# Install biomRt from development version. You need to install the "png" package
# (install.packages("png")) as well.
# BiocManager::install('grimbough/biomaRt')

library(OpenML)
library(farff)
library(readr)
library(fuseMLR)
library(ranger)
library(glmnet)
library(e1071)
library(data.table)
library(ggplot2)
# To retrieve chromosome information from miRNA.
library(mirbase.db) 
# To retrieve chromosome from mRNA.
library(biomaRt)

# Set the absolute path to your project directory.
project_dir <- "~/projects/interconnect-publications/fuseMLR-paper"
data_dir <- file.path(project_dir, "data")
result_dir <- file.path(project_dir, "results")
dir.create(path = data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(path = result_dir, recursive = TRUE, showWarnings = FALSE)

# Source learners
source(file.path(project_dir, "mylasso.R"))
source(file.path(project_dir, "mysvm.R"))
