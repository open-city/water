setwd("~/Dropbox/CivicHack/Water")

#Scott thinks this is from O'Hare
forecast_data <- read.csv("./data/forecast/iohourlyforecast.csv")

names(forecast_data) <- c("id", "start_time", "precip_intensity", "forecast_time")
forecast_data$start_time <- strptime(as.character(forecast_data$start_time), format="%Y-%m-%d %H:%M:%S")
forecast_data$num_start <- as.numeric(forecast_data$start_time)
forecast_data$forecast_time <- strptime(as.character(forecast_data$forecast_time), format="%Y-%m-%d %H:%M:%S")
water_data <- data.frame(water_data)
merged_forecast_precip <- merge(forecast_data, water_data)
cor(merged_forecast_precip[ , c("precip_intensity", precip_names)] )

 <- read.csv("./data/plenar.io/o_hare_rainfall.json")

precip_names <- c("arr_precip", "dpa_precip", "igq_precip", "lot_precip", "mdw_precip"
                  ,"ord_precip", "pwk_precip", "ugn_precip")


