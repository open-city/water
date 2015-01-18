library(rjson)
library(data.table)

setwd("~/Dropbox/CivicHack/Water")

rainfall_locations <- c("arr", "dpa", "igq", "lot", "mdw", "ord", "pwk", "ugn")
long_data <- list()
master_data <- data.frame()
#library(data.table)
for(prefix in rainfall_locations){
  wide_data <- unlist(fromJSON(file=paste0("./data/precip_json/", prefix, "_json.txt")))
  print(wide_data[1:4])
  df_data <- data.frame(start=wide_data[names(wide_data) == "start"], end=wide_data[names(wide_data) == "end"],
                        precip=wide_data[names(wide_data) == "precipitationInches"])
  df_data$start <- strptime(as.character(df_data$start), format="%m/%d/%Y %H:%M:%S")
  df_data$end <- strptime(as.character(df_data$end), format="%m/%d/%Y %H:%M:%S")
  df_data$precip <- as.numeric(as.character(df_data$precip))
  names(df_data) <- c("start", "end", paste0(prefix, "_precip"))
  if(nrow(master_data) == 0) master_data <- df_data
  else master_data <- merge(master_data, df_data, all=TRUE)  
}

master_data_copy <- master_data

master_data$num_start <- as.numeric(master_data$start)
master_data$num_end <- as.numeric(master_data$end)
master_data <- master_data[order(master_data$num_start), ]
no_time <- which(master_data$num_end - master_data$num_start == 0)
#no_time locations correspond to daylight savings time
master_data$num_end[no_time] <- master_data$num_end[no_time] + 3600

break_points <- which(diff(master_data$num_end, 1) == 7200)


to_pop_out <- c()

duped_ins <- c(seq(1, break_points[1]))
for(i in seq(1, (length(break_points) - 1))){
  duped_ins <- c(duped_ins, seq(break_points[i], break_points[i + 1]))
}
duped_ins <- c(duped_ins, seq(break_points[i + 1], nrow(master_data)))
extended_master_data <- master_data[duped_ins,]


raw_sewage <- read.csv("./data/sewage/cso_dat.csv", header=TRUE)
processed_sewage <- raw_sewage
processed_sewage$num_start <- unlist(apply(raw_sewage[,c("Date", "StartTime")], 1, function(x) as.numeric(strptime(paste(x, collapse=" "), 
      format="%Y-%m-%d %H:%M"))))
processed_sewage$num_end <- processed_sewage$num_start + processed_sewage$Duration
processed_sewage$Location <- as.character(processed_sewage$Location)
processed_sewage$Segment <- as.character(processed_sewage$Segment)

for(segment in names(table(processed_sewage$Segment))){
  extended_master_data[,segment] <- 0
}

for(location in names(table(processed_sewage$Location))){
  extended_master_data[,location] <- 0
}

start_time <- min(extended_master_data$num_start)
end_time <- min(extended_master_data$num_end)

get_start <- function(sewage_start_time, global_start_time){
  ceiling((sewage_start_time + 0.1 - global_start_time) / 3600)
}

#sanity check
mean(extended_master_data$num_start == 3600 * (1:n) + start_time - 3600)
#test out this method using processed_sewage
for(i in sample(nrow(processed_sewage), 100)){
  print(i)
  sewage_indices <- seq(get_start(processed_sewage$num_start[i], start_time), get_start(processed_sewage$num_end[i], start_time))
  print(processed_sewage[i, c("Date", "StartTime", "EndTime","num_start", "num_end")])
  print(extended_master_data[sewage_indices, c("start", "end","num_start", "num_end")])
}

for(i in seq(1, nrow(processed_sewage))){
  spill_segment <- processed_sewage$Segment[i]
  spill_location <- processed_sewage$Location[i]
  spill_indices <- seq(get_start(processed_sewage$num_start[i], start_time), get_start(processed_sewage$num_end[i], start_time))
  extended_master_data[spill_indices, c(spill_segment, spill_location)] <- 1
}

master_data_no_dupls <- extended_master_data[-(break_points + 1:7), ]
names(master_data_no_dupls)[13:36] <- paste0("segment_", names(master_data_no_dupls)[13:36])

precip_names <- paste0(rainfall_locations, "_precip")
outside_precip_window <- apply(master_data_no_dupls[, precip_names], 1, function(x) all(is.na(x)))
master_data_dropped <- master_data_no_dupls[!outside_precip_window,]
master_data_dropped[is.na(master_data_dropped)] <- 0
saveRDS(master_data_dropped, file="./data/derived/munged_data.RDS")