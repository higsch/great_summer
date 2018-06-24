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
  # filter for relevant columns: temp and wind
  table <- table[, c("Day", "T", "V")]
  # only keep rows with day-wise data (no final means etc.)
  table <- table[grep("^([1-3]|)[0-9]", table$Day), ]
  return(table)
}