##############################################################################
# Week 3 Task: Statistical Analysis and Predictive Modeling in R
# Dataset : Breast Cancer Wisconsin (Diagnostic) Dataset
# Author  : Kartik Kumar
# Date    : August 15, 2026
##############################################################################

# ---- 0. SETUP --------------------------------------------------------------
# install.packages(c("tidyverse","caret","corrplot","car","pROC",
#                    "randomForest","broom"))

library(tidyverse)
library(caret)
library(corrplot)
library(car)
library(pROC)
library(randomForest)
library(broom)

set.seed(123)

# ---- 1. DATASET IDENTIFICATION --------------------------------------------
# Breast Cancer Wisconsin (Diagnostic) dataset: 569 observations,
# 30 numeric predictors and a binary diagnosis (B = benign, M = malignant).
bc_data <- read.csv("breast_cancer_data.csv", stringsAsFactors = FALSE)
bc_data$diagnosis <- factor(bc_data$diagnosis, levels = c("B", "M"))

str(bc_data)
dim(bc_data)
sum(is.na(bc_data))
table(bc_data$diagnosis)
prop.table(table(bc_data$diagnosis))

# ---- 2. EXPLORATORY STATISTICAL ANALYSIS ----------------------------------
summary(bc_data[, grep("^mean_", names(bc_data))])

ggplot(bc_data, aes(x = diagnosis, fill = diagnosis)) +
  geom_bar() +
  labs(title = "Class Distribution of Diagnosis", x = "", y = "Count") +
  theme_minimal()

# Normality checks on representative continuous variables
shapiro.test(bc_data$mean_radius)
shapiro.test(bc_data$mean_area)
shapiro.test(bc_data$mean_texture)
shapiro.test(bc_data$mean_smoothness)

key_vars <- c("mean_radius", "mean_texture", "mean_concavity", "mean_smoothness")
bc_data %>%
  select(diagnosis, all_of(key_vars)) %>%
  pivot_longer(-diagnosis, names_to = "variable", values_to = "value") %>%
  ggplot(aes(x = diagnosis, y = value, fill = diagnosis)) +
  geom_boxplot() +
  facet_wrap(~variable, scales = "free_y") +
  theme_minimal() +
  labs(title = "Distribution of Key Features by Diagnosis")

# ---- 3. HYPOTHESIS TESTING & CORRELATION -------------------------------
t_test_vars <- c("mean_radius", "mean_texture", "mean_perimeter", "mean_area",
                 "mean_smoothness", "mean_compactness", "mean_concavity",
                 "mean_concave_points")

t_test_results <- lapply(t_test_vars, function(v) {
  t.test(bc_data[[v]] ~ bc_data$diagnosis)
})
names(t_test_results) <- t_test_vars
t_test_results

car::leveneTest(mean_radius ~ diagnosis, data = bc_data)

mean_vars <- grep("^mean_", names(bc_data), value = TRUE)
corr_matrix <- cor(bc_data[, mean_vars], method = "pearson")
round(corr_matrix, 2)

corrplot(corr_matrix, method = "color", type = "upper",
         addCoef.col = "black", number.cex = 0.6, tl.cex = 0.8,
         title = "Correlation Matrix: Mean Tumor Characteristics",
         mar = c(0, 0, 2, 0))

# ---- 4. EXPLANATORY LOGISTIC REGRESSION -------------------------------
glm_vars <- c("mean_radius", "mean_texture", "mean_smoothness", "mean_compactness",
              "mean_concavity", "mean_concave_points", "mean_symmetry",
              "mean_fractal_dimension")

glm_data <- bc_data %>%
  select(diagnosis, all_of(glm_vars)) %>%
  mutate(across(all_of(glm_vars), ~ as.numeric(scale(.))))

glm_model <- glm(diagnosis ~ ., data = glm_data, family = binomial(link = "logit"))
summary(glm_model)
exp(coef(glm_model))
confint(glm_model)
vif(glm_model)

# ---- 5. PREDICTIVE MODELING: TRAIN/TEST + 10-FOLD CV -------------------
feature_cols <- setdiff(names(bc_data), "diagnosis")

train_index <- createDataPartition(bc_data$diagnosis, p = 0.70, list = FALSE)
train_data <- bc_data[train_index, ]
test_data  <- bc_data[-train_index, ]

table(train_data$diagnosis)
table(test_data$diagnosis)

ctrl <- trainControl(method = "cv", number = 10,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary,
                     savePredictions = TRUE)

model_glm_cv <- train(diagnosis ~ ., data = train_data, method = "glm",
                      family = "binomial", trControl = ctrl,
                      preProcess = c("center", "scale"), metric = "ROC")
print(model_glm_cv)

model_rf_cv <- train(diagnosis ~ ., data = train_data, method = "rf",
                     trControl = ctrl, preProcess = c("center", "scale"),
                     metric = "ROC", ntree = 500)
print(model_rf_cv)

# ---- 6. HELD-OUT TEST EVALUATION ------------------------------------------
pred_glm <- predict(model_glm_cv, newdata = test_data)
prob_glm <- predict(model_glm_cv, newdata = test_data, type = "prob")[, "M"]

pred_rf <- predict(model_rf_cv, newdata = test_data)
prob_rf <- predict(model_rf_cv, newdata = test_data, type = "prob")[, "M"]

cm_glm <- confusionMatrix(pred_glm, test_data$diagnosis, positive = "M")
cm_rf  <- confusionMatrix(pred_rf, test_data$diagnosis, positive = "M")
cm_glm
cm_rf

roc_glm <- roc(response = test_data$diagnosis, predictor = prob_glm,
               levels = c("B", "M"))
roc_rf <- roc(response = test_data$diagnosis, predictor = prob_rf,
              levels = c("B", "M"))

plot(roc_glm, col = "blue", main = "ROC Curves: Test Set Performance")
plot(roc_rf, col = "red", add = TRUE)
legend("bottomright",
       legend = c(paste0("Logistic Regression (AUC=", round(auc(roc_glm), 3), ")"),
                  paste0("Random Forest (AUC=", round(auc(roc_rf), 3), ")")),
       col = c("blue", "red"), lwd = 2)

auc(roc_glm)
auc(roc_rf)

# GLM residual and influence diagnostics
par(mfrow = c(2, 2))
plot(glm_model)
par(mfrow = c(1, 1))

cooksd <- cooks.distance(glm_model)
plot(cooksd, type = "h", main = "Cook's Distance", ylab = "Cook's distance")
abline(h = 4 / nrow(glm_data), col = "red", lty = 2)
influential <- which(cooksd > 4 / nrow(glm_data))
length(influential)

# Random forest variable importance
varImpPlot(model_rf_cv$finalModel, main = "Random Forest Variable Importance", n.var = 12)
importance_df <- importance(model_rf_cv$finalModel)
importance_df[order(-importance_df[, "MeanDecreaseGini"]), ][1:10, ]

# Cross-validation comparison
resamps <- resamples(list(LogisticRegression = model_glm_cv,
                          RandomForest = model_rf_cv))
summary(resamps)
bwplot(resamps, metric = "ROC")

##############################################################################
# The objects created here (bc_data, test_data, prob_glm, prob_rf, models,
# etc.) are intentionally available for advanced_analysis.R.
##############################################################################
