# Ensure you have installed the following packages.

# install.packages("OpenML")
# install.packages("farff")
# install.packages("readr")
# install.packages("fuseMLR")
# install.packages("ranger")
# install.packages("Boruta")
# install.packages("glmnet")
# install.packages("e1071")
# install.packages("data.table")
# install.packages("ggplot2")
# install.packages("here")
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("mirbase.db")
# Install biomaRt from development version. Packages "png" and "remotes" required.
# install.packages("png")
# BiocManager::install("remotes")
# BiocManager::install('grimbough/biomaRt')

library(OpenML)
library(farff)
library(readr)
library(fuseMLR)
library(ranger)
library(Boruta)
library(glmnet)
library(e1071)
library(data.table)
library(ggplot2)
library(here)
# To retrieve chromosome information from miRNA.
library(mirbase.db) 
# To retrieve chromosome from mRNA.
library(biomaRt)

# Set the absolute path to your project directory.
case_study_dir <- here("02-case-study")
data_dir <- file.path(case_study_dir, "data")
result_dir <- file.path(case_study_dir, "results")
dir.create(path = data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(path = result_dir, recursive = TRUE, showWarnings = FALSE)

# Source learners
source(file.path(case_study_dir, "mylasso.R"))
source(file.path(case_study_dir, "mysvm.R"))
