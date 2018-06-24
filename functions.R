getWeatherData <- function (url) {
  # download html and parse
  page <- getURL(url, .opts = list(ssl.verifypeer = FALSE))
  doc <- htmlParse(page)
  tableNodes = getNodeSet(doc, "//table")
  # retrieve monthly weather table from web
  id <- 4
  table <- readHTMLTable(doc = tableNodes[[id]],
                         header = TRUE,
                         stringsAsFactors = FALSE,
                         as.data.frame = TRUE)
  # only keep rows with day-wise data (no final means etc.)
  table <- table[grep("^([1-3]|)[0-9]", table$Day), ]
  # make interesting columns numeric
  table <- data.frame(Day = as.numeric(table$Day),
                      Temperature = as.numeric(table$T),
                      Wind = as.numeric(table$V))
  return(table)
}

calculateTempDayMedian <- function (day, data) {
  return(median(data[which(data$Day == day), "Temperature"], na.rm = TRUE))
}
