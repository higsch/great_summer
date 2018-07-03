library(XML)
library(RCurl)
library(dplyr)
library(data.table)
library(reshape2)
library(ggplot2)
theme_set(theme_classic())

source("functions.R")

calculateTempDayMedian <- function (day, data) {
  return(median(data[which(data$Day == day), "Temperature"], na.rm = TRUE))
}

data <- fetchData()

# plot May 2018
ggplot(data = data[which(data$Year == 2018), ]) +
  geom_line(aes(x = Day, y = Temperature), colour = "red")

# all years
ggplot(data = data) +
  geom_line(aes(x = Day, y = Temperature, colour = Year))

# look at the temperature distribution
ggplot(data = data) +
  geom_histogram(aes(Temperature), binwidth = 0.3)

# build median tempertures for each day
data_wide <- reshape(data, idvar = "Day", timevar = "Year", direction = "wide")
data_wide$median <- apply(data_wide[, 2:ncol(data_wide)],
                   MARGIN = 1,
                   FUN = median,
                   na.rm = TRUE)

ggplot(data = data_wide) +
  geom_line(aes(x = Day, y = median)) +
  geom_line(data = data[which(data$Year == 2018), ], aes(x = Day, y = Temperature), colour = "red")

# calculate temperature differences to median
data$year_median <- apply(data,
                          MARGIN = 1,
                          FUN = function (d, data_wide) {
                            data_wide[which(data_wide$Day == trimws(d[["Day"]])), "median"]
                          },
                          data_wide = data_wide)

data$median_diff <- data$Temperature - data$year_median

ggplot(data = data) +
  geom_line(aes(x = Day, y = median_diff, colour = Year))