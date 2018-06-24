library(XML)
library(RCurl)
library(dplyr)
library(data.table)
library(reshape2)
library(ggplot2)
theme_set(theme_classic())

source("functions.R")

# base URL for weather data download
base_url <- "https://en.tutiempo.net/climate/05-%s/ws-24640.html"
# years to search for
years <- c(1998:2018)


# create list of data containing URLs
urls <- sapply(as.character(years),
               function (x, base_url) {
                 sprintf(base_url, x)
               },
               base_url = base_url,
               simplify = FALSE)

# fetch data
data_list <- sapply(urls,
                    getWeatherData,
                    simplify = FALSE)

# combine all the data
data <- bind_rows(data_list, .id = "Year")

# plot May 2018
ggplot(data = data[which(data$Year == 2018), ]) +
  geom_line(aes(x = Day, y = Temperature), colour = "red")

# all years
ggplot(data = data) +
  geom_line(aes(x = Day, y = Temperature, colour = Year))

# build median tempertures for each day
median_data_list <- sapply(as.character(unique(data$Day)),
                           calculateTempDayMedian,
                           data = data,
                           simplify = FALSE)
median_data <- data.frame(Day = as.numeric(names(median_data_list)),
                          Temperature = unlist(median_data_list, use.names = FALSE))

ggplot(data = median_data) +
  geom_line(aes(x = Day, y = Temperature)) +
  geom_line(data = data[which(data$Year == 2018), ], aes(x = Day, y = Temperature), colour = "red")

# calculate temperature differences to median
median_diff_list <- sapply(as.character(unique(data$Day)),
       function (d, years, data, median_data) {
         sapply(as.character(years),
                function (y, d, data, median_data) {
                  data[which(data$Year == y & data$Day == d), "Temperature"] - median_data[which(median_data$Day == d), "Temperature"]
                },
                d = d,
                data = data,
                median_data = median_data,
                simplify = FALSE)
       },
       years = years,
       data = data,
       median_data = median_data,
       simplify = FALSE)

median_diff <- rbindlist(median_diff_list, fill = TRUE, idcol = "Day")
median_diff <- melt(median_diff, id.vars = "Day", variable.name = "Year", value.name = "Median_diff_temp")
median_diff$Day <- as.numeric(median_diff$Day)

ggplot(data = median_diff) +
  geom_line(aes(x = Day, y = Median_diff_temp, colour = Year))