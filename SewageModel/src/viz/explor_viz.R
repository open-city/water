seg_ins <- 13:36
pipe_ins <- 37:266

eigen(cor(sewage_data[, 13:36]))
heatmap(cor(sewage_data[, 13:36]))
heatmap.2(cor(sewage_data[, 13:36]), col=bluered, trace="none")
heatmap.2(cor(sewage_data[, 37:266]), col=bluered, trace="none")
clusters <- kmeans(sewage_data[, pipe_ins], centers=6)
eigen_sewage <- eigen(cor(sewage_data[, 37:266]))
plot(eigen_sewage$values)
hist(colSums(sewage_data[, 37:266]))
plot(density(colSums(sewage_data[, 37:266]), from=0))
sum(colSums(sewage_data[, 37:266]))
sum(apply(sewage_data[, 37:266], 1, function(x) min(1, sum(x))))

precip_names <- c("arr_precip", "dpa_precip", "igq_precip", "lot_precip", "mdw_precip"
                  ,"ord_precip", "pwk_precip", "ugn_precip")

precip_want_to_sum <- c()
for(precip_name in precip_names){
  for(i in 1:8){
    precip_want_to_sum <- c(precip_want_to_sum, paste0(precip_name, "_", i))
  }
}

rainfall_6_back <- rowSum()

big_precip_data <- data.frame()

for(segment_name in segment_names){
  big_precip_data <- rbind(big_precip_data, 
                           cbind(precip_data, sewage_data[[segment_name]]))  
}

precip_8_back <- rowSums(precip_data[, precip_want_to_sum])

new_df <- data.frame(sewage_data$segment_1 , precip_8_back)
new_df$sewage_data.segment_3 <- as.factor(new_df$sewage_data.segment_3)
ggplot(new_df, aes(x=precip_8_back, fill=sewage_data.segment_3)) + geom_density(alpha=.3)


any_segment <- apply(sewage_data[, segment_names], 1, function(x) min(sum(x), 1))
mean_segment <- apply(sewage_data[, 37:266], 1, mean)
