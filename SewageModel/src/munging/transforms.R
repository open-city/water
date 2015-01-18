setwd("~/Dropbox/CivicHack/Water")
#data.table
precip_data <- readRDS("./data/derived/munged_data.RDS")
rainfall_locations <- c("arr", "dpa", "igq", "lot", "mdw", "ord", "pwk", "ugn")
precip_names <- paste0(rainfall_locations, "_precip")
precip_data <- precip_data[, precip_names]

#segment_names <- unlist((names(water_data)[substr(names(water_data), 1, 8) == "segment_"]))
#sum(apply(water_data[, segment_names], 1, function(a_row) any(as.logical(a_row))))
#sum(apply(water_data[, 11:264], 1, function(a_row) any(as.logical(a_row))))

days_back <- c(25, 49, 73, 97)
n <- nrow(precip_data)
precip_data$index <- 1:n
merged_precip <- precip_data
for(i in c(1:24, days_back)){
  temp_data <- precip_data[i:n,]
  temp_data$index <- temp_data$index - i + 1
  merged_precip <- merge(merged_precip, temp_data, by="index", suffixes=c("", paste0("_", i)),  all=TRUE)  
}

merged_precip[is.na(merged_precip)] <- 0

for(precip_name in precip_names){
  for(i in days_back){
    name_orig <- paste0(precip_name, "_", i)
    name_24hrsum <- paste0(precip_name, "_", i, "_24hrsum")
    cum_sum <- cumsum(merged_precip[[name_orig]])
    sum_24hr <- cum_sum - c(rep(0, 24), cum_sum[seq(1, n- 24)])
    merged_precip[[name_24hrsum]] <- sum_24hr
  }
}

dropped_merged_precip <- merged_precip[, -(1:9)]

saveRDS(dropped_merged_precip, file="./data/derived/transformed_precip.RDS")
