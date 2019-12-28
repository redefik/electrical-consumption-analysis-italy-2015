# Remove Solar Energy-related field from the dataset and remove missing values
data_cleaning <- function(dataset) {
  cat("Data cleaning...\n")
  # Remove observations dealing with solar energy consumption
  out <- dataset[,-ncol(dataset)]
  # Remove missing values
  available_obs <- complete.cases(out)
  out <- out[which(available_obs),]
  cat("Done\n")
  return(out)
}