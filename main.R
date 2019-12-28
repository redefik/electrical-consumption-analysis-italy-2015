################################################################################
# This project deals with the analysis of a time series reporting the hourly   #
# consumption of electrical energy registered in Italy during 2015.            #
# The focus is mainly on the data preparation stage that should preceed every  #
# time series analysis.
# The dataset is available  at:                                                #
# https://www.kaggle.com/arielcedola/solar-generation-and-demand-italy-20152016#
################################################################################

# Author: Federico Viglietta

library(fpp2)
library(gridExtra)

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

# Data Cleaning
cleaned_data <- data_cleaning(data)

# Embed time series in a ts object
time_series <- ts(cleaned_data, frequency=24)
# Display time plot
autoplot(time_series) +
  ggtitle("Hourly Electrical Consumption - Italy - 2015") +
  xlab("Days") +
  ylab("MegaWatt")

# Now, we extract observation from April
ts_april <- window(time_series, start=90, end=119)
# Display the corresponding time plot
autoplot(ts_april) +
  ggtitle("Hourly Electrical Consumption - Italy - 2015 - April") +
  xlab("Days") +
  ylab("MegaWatt")
# The time series neither increase nor decrease in a long-term way
# However, let's estimate the trend using moving average
# We have hourly data with daily seasonality, thus we use a centred moving 
# average with order 24
trend_estimate <- ma(ts_april, 24, centre=TRUE)
# Let's compare estimate trend and original time series
autoplot(ts_april, series="Original") +
  autolayer(trend_estimate, series="24-MA centred") +
  xlab("Day") + ylab("MegaWatt") +
  ggtitle("Hourly Electrical Consumption - Italy - 2015 - April") +
  scale_colour_manual(values=c("Original"="grey","24-MA centred"="red"),
                      breaks=c("Original","24-MA centred"))

# Let's check for seasonal patterns
ggsubseriesplot(ts_april) +
  ggtitle("Seasonal Subseries Plot Hourly Electrical Consumption April") +
  xlab("Hour") +
  ylab("MegaWatt")
ggseasonplot(ts_april, year.labels=T) +
  ggtitle("Seasonal Plot Hourly Electrical Consumption April") +
  xlab("Hour") +
  ylab("MegaWatt")
# As expected the average consumption is higher from 7 AM to 21 PM

# The presence of a seasonal pattern implies that the time series is not stationary
# The layout of the autocorrelation function for the given time series confirms that:
autoplot(Acf(ts_april, lag.max=300)) +
  ggtitle("ACF Time Series - April 2015")

# Finally, we plot the output of the automatic additive decomposition performed by R
deca <- decompose(ts_april, type="additive")
autoplot(deca) + ggtitle("Additive Decomposition of Time Series")
# Note that the trend doesn't show neither an increasing behaviour nor a 
# a decreasing one on the long term, in according to the previous considerations





