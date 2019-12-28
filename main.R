################################################################################
# This project deals with the analysis of a time series reporting the hourly   #
# consumption of electrical energy registered in Italy during 2015.            #
# The dataset is available  at:                                                #
# https://www.kaggle.com/arielcedola/solar-generation-and-demand-italy-20152016#
################################################################################

# Author: Federico Viglietta

library(fpp2)

source("import_dataset.R")
source("data_understanding.R")
source("data_cleaning.R")

# Import dataset
data <- import_dataset("TimeSeries_TotalSolarGen_and_Load_IT_2015.csv")

# Data Understanding
data_summary <- data_understanding(data)

# data_summary reveals that the dataset includes 8760 instances.
# For each instance three information are available:
# 1. utc_timestamp: Date and Time of the observation, expressed in UTC
# 2. IT_load_new: Total electricity consumption registered
# 3. IT_solar_generation: Solar power generation registered
# In this project we are interested in the total consumption only, thus we will
# remove IT_solar_generation field.
# data_summary shows that 359 observations are missing too
# Finally, there are no duplicated values and no outliers

cleaned_data <- data_cleaning(data)
