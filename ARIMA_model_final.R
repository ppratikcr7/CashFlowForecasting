# ARIMA modelling for cashflow prediction:

# install libraries:
install.packages("forecast")
install.packages("dplyr")    # alternative installation of the %>%
install.packages("data.table")

# importing libraries:
require(forecast)
library(dplyr)
library(data.table)

# Loading data:
dataset <- read.csv("monthly_data_training_arima.csv")
#attach(dataset)

# Find unique account id's to groupby:
uniqueAccounts = unique(dataset$account_id)
result <- list()
h = 1 # this is the number of next values to predict (we want only july 2019, so 1)

for( i in 1:length(uniqueAccounts)){
  # Get subset if each group by account id:
  data_subset = subset(dataset, dataset$account_id == uniqueAccounts[i])
  # Define ARIMA model:
  model <- auto.arima(data_subset$amount_usd)
  # Store the result in a Data Frame
  result[[i]] <- data.frame(account_id = uniqueAccounts[i],
                            amount_usd = forecast(model, h=h)$mean)
}

# Bind the dataframe into data table
result <- data.table::rbindlist(result)
# Write ouptut to submission csv:
write.csv(x=result, file="submission_Arima.csv")