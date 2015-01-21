library(gbm)
library(pROC)
library(glmnet)
library(gplots)
library(ggplot2)
require(doMC)
registerDoMC(cores=5)


setwd("~/Dropbox/CivicHack/Water")
sewage_data <- readRDS("./data/derived/munged_data.RDS")
precip_data <- readRDS("./data/derived/transformed_precip.RDS")

segment_names <- c("segment_1",  "segment_11", "segment_12", "segment_13", 
                   "segment_14", "segment_15", "segment_16", "segment_17",
                   "segment_18", "segment_19", "segment_2",  "segment_20",
                   "segment_21", "segment_23", "segment_3",  "segment_30",
                   "segment_31", "segment_32", "segment_4",  "segment_5",  
                   "segment_6", "segment_7",  "segment_8",  "segment_9" )
precip_names <- c("arr_precip", "dpa_precip", "igq_precip", "lot_precip", "mdw_precip"
                  ,"ord_precip", "pwk_precip", "ugn_precip")

n <- nrow(precip_data)

pipe_ins <- 37:266
total_locns <- length(pipe_ins)

precip_ins_to_use <- 1:10
precip_ins_to_use <- c(1:192, 230:256)
precip_ins_to_use <- c(1:65, 230:256)

predictors <- precip_data
predictors[["month"]] <- factor(sapply(as.character(sewage_data[["start"]]), function(x) strsplit(x, "-")[[1]][2]))
the_months <- as.numeric((sapply(as.character(sewage_data[["start"]]), function(x) strsplit(x, "-")[[1]][2])))
month_matrix <- matrix(0, n, 11)

for(i in 1:11){
  month_matrix[the_months == i, i] <- 1 
}

predictor_matrix <- as.matrix(predictors[, precip_ins_to_use])

big_predictor_matrix <- cbind(predictor_matrix, month_matrix)

outcome <- rowSums(sewage_data[, pipe_ins])
#outcome <- as.matrix(cbind(outcome, total_locns - outcome))
outcome <- as.matrix(cbind(total_locns - outcome, outcome))


full_glm <- glm.fit(big_predictor_matrix, outcome, family=binomial(link = "logit"))

wzl <- glmnet(predictor_matrix, outcome, alpha=0.5, family="binomial")
wzl <- cv.glmnet(big_predictor_matrix, outcome, alpha=0.5, family="binomial", parallel=TRUE)
wzl <- cv.glmnet(as.matrix(predictors), outcome, alpha=0.5, family="binomial")
wzl <- cv.glmnet(predictor_matrix, outcome, alpha=0.5, family="binomial")
wzl <- cv.glmnet(as.matrix(predictor_matrix), water_data$segment_1[2:n], alpha=0.5, family="binomial")
plot(density(predict(wzl, as.matrix(predictor_matrix[outcome[,2] == 0,]), s="lambda.min")))
lines(density(predict(wzl, as.matrix(predictor_matrix[outcome[,2] > 0,]), s="lambda.min")), col="red")
for(i in 1:12){
  print(i)
  print(mean(predict(wzl, big_predictor_matrix[the_months == i, ], type="response", s=-9)) * total_locns)
  print(mean(outcome[the_months == i, 2]))
}


for(i in 1:12){
  print(i)
  print(mean(full_glm$y[the_months == i]) * 230)
  print(mean(outcome[the_months == i, 1]))
}


#difference in class membership of 0.02873

#wzl <- cv.glmnet(as.matrix(predictor_matrix), water_data$segment_1[2:n], alpha=1, family="binomial")


setkeyv(water_data, c("rollup_indices"))
unique_water_data <- unique(water_data)

merge(water_data, water_data[2:n,],)

water_data$one_back_segment_1 <- c(water_data$segment_1_sewage[2:n], NA)
modeling_data <- unique(water_data)
n <- nrow(modeling_data)
train_indices <- seq(1, floor(0.6 * n))

wzl <- glm(one_back_segment_1~arr_precip_agg+dpa_precip_agg+igq_precip_agg+lot_precip_agg+mdw_precip_agg+ord_precip_agg+pwk_precip_agg+ugn_precip_agg,data=modeling_data[train_indices,], family=binomial)
predicted_glm <- predict.glm(wzl, newdata=modeling_data[-train_indices, ])
glm_roc <- roc(modeling_data[-train_indices, c(one_back_segment_1)], predicted_glm)
plot(glm_roc)
summary(glm_model)
actual_sewage <- modeling_data$one_back_segment_1[-train_indices]
plot(density(predicted_glm[!as.logical(actual_sewage)]))
lines(density(predicted_glm[as.logical(actual_sewage)]), col="red")



#take first 60% of observations to train on
#out of time validation is a pretty good test of a model's validity!

modeling_data <- data.frame(merged_precip[, -1, with=FALSE], sewage_1=water_data$segment_1)
train_indices <- seq(1, floor(0.6 * n))
lm_formula <- as.formula(paste0("sewage_1 ~ ", paste0(setdiff(names(merged_precip), c("index",
                                                                                      "sewage_1" )), collapse=" + ")))
lm_no_current_formula <- as.formula(paste0("sewage_1 ~ ", paste0(setdiff(names(merged_precip), c("index", precip_names,
                                                                                         "sewage_1" )), collapse=" + ")))

glm_model <- glm(formula=lm_formula, data=modeling_data[train_indices,], family=binomial)
glm_model <- glm(formula=lm_no_current_formula, data=modeling_data[train_indices,], family=binomial)
predicted_glm <- predict.glm(glm_model, newdata=modeling_data[-train_indices, ])
glm_roc <- roc(modeling_data[-train_indices, "sewage_1"], predicted_glm)
plot(glm_roc)
summary(glm_model)

stoat <- gbm(formula=lm_formula, data=modeling_data[train_indices,], distribution="bernoulli", n.trees=1000,
             shrinkage=0.01, n.cores=5, cv.folds=5)
predicted_obs <- predict.gbm(stoat, newdata=modeling_data[-train_indices,])
actual_sewage <- modeling_data[-train_indices, "sewage_1"]

predicted_validate_sewage <- predicted_obs[as.logical(actual_sewage)]
predicted_validate_no_sewage <- predicted_obs[!as.logical(actual_sewage)]

predictors <- setdiff(names(merged_precip), c("index", 
                                              "sewage_1"))
response <- "sewage_1" 

plot(density(predicted_obs[!as.logical(actual_sewage)]))
lines(density(predicted_obs[as.logical(actual_sewage)]), col="red")
stoat_roc <- roc(modeling_data[actual_sewage, pred
                               
                               library(glmnet)
                               require(doMC)
                               registerDoMC(cores=5)
                               
                               omitted_modeling_data <- na.omit(modeling_data)
                               cats <- glmnet(as.matrix(omitted_modeling_data[, predictors]), as.matrix(omitted_modeling_data[, response]), family="binomial")
                               
                               
                               summary(modeling_data)1