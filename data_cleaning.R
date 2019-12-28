library(imputeTS)

# Remove Solar Energy-related field from the dataset and handle missing values
data_cleaning <- function(dataset) {
  cat("Data cleaning...\n")
  # Data dealing with solar energy consumption are removed
  # Missing values are handled. Namely:
  # We cannot remove them
  # For sake of simplicity we replace each missing observation with the Last
  # Observation Carried Forward
  replaced_missing <- na_locf(dataset[,2], option = "locf")
  cat("Done\n")
  return(replaced_missing)
}