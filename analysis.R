library(XML)
library(RCurl)
library(dplyr)
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
  geom_line(aes(x = Day, y = Temperature))

# all years
ggplot(data = data) +
  geom_line(aes(x = Day, y = Temperature, colour = Year))

# build medians of for each day
