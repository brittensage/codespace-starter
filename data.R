library(jsonlite)

latitude <- 27.3364
longitude <- -82.5307
start_date <- Sys.Date() - 7
end_date <- Sys.Date() - 1

query <- paste0(
  "https://archive-api.open-meteo.com/v1/archive?",
  "latitude=", latitude,
  "&longitude=", longitude,
  "&start_date=", start_date,
  "&end_date=", end_date,
  "&hourly=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m",
  "&temperature_unit=fahrenheit",
  "&wind_speed_unit=mph",
  "&precipitation_unit=inch",
  "&timezone=America%2FNew_York"
)

weather <- fromJSON(query)

hourly <- data.frame(
  time = as.POSIXct(weather$hourly$time, format = "%Y-%m-%dT%H:%M", tz = "America/New_York"),
  temperature_f = weather$hourly$temperature_2m,
  humidity_percent = weather$hourly$relative_humidity_2m,
  precipitation_in = weather$hourly$precipitation,
  wind_speed_mph = weather$hourly$wind_speed_10m
)

dir.create("data", showWarnings = FALSE)
write.csv(hourly, "data/sarasota-hourly-weather.csv", row.names = FALSE)
message("Downloaded ", nrow(hourly), " hourly observations to data/sarasota-hourly-weather.csv")