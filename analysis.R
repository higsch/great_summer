library(XML)
library(RCurl)

# base URL for weather data download
base_url <- "https://en.tutiempo.net/climate/06-%s/ws-24640.html"
# years to search for
years <- c(2012:2018)


# create list of data containing URLs
urls <- sapply(as.character(years),
               function (x, base_url) {
                 sprintf(base_url, x)
               },
               base_url = base_url,
               simplify = FALSE)

# fetch data
data <- sapply(urls,
               getWeatherData,
               simplify = FALSE)

