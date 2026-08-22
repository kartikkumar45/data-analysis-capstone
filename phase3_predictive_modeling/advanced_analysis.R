##############################################################################
# Advanced Model Evaluation and Decision Analysis
# Dataset / objects: Breast Cancer Wisconsin (Diagnostic)
# Author: Kartik Kumar
# Purpose: Extend the main Week 3 workflow with effect sizes, precision-recall
#          analysis, and illustrative cost-sensitive threshold analysis.
#
# Run predictive_modeling.R first. This script intentionally uses objects
# created there (bc_data, test_data, prob_glm, prob_rf, model_glm_cv, model_rf_cv).
##############################################################################

# install.packages(c("PRROC", "pROC", "caret"))
library(PRROC)
library(pROC)
library(caret)

# ---- 1. STANDARDIZED EFFECT SIZES -----------------------------------------
cohens_d <- function(a, b) {
  pooled_sd <- sqrt(((length(a) - 1) * var(a) +
                     (length(b) - 1) * var(b)) /
                    (length(a) + length(b) - 2))
  (mean(a) - mean(b)) / pooled_sd
}

t_test_vars <- c("mean_radius", "mean_texture", "mean_perimeter", "mean_area",
                 "mean_smoothness", "mean_compactness", "mean_concavity",
                 "mean_concave_points")

cohen_d_results <- sapply(t_test_vars, function(v) {
  cohens_d(bc_data[[v]][bc_data$diagnosis == "M"],
           bc_data[[v]][bc_data$diagnosis == "B"])
})
print(cohen_d_results)

# ---- 2. PRECISION-RECALL ANALYSIS -----------------------------------------
# The malignant class is the positive class.
pr_glm <- pr.curve(
  scores.class0 = prob_glm,
  weights.class0 = as.numeric(test_data$diagnosis == "M"),
  curve = TRUE
)

pr_rf <- pr.curve(
  scores.class0 = prob_rf,
  weights.class0 = as.numeric(test_data$diagnosis == "M"),
  curve = TRUE
)

plot(pr_glm, main = "Precision-Recall Curves: Held-Out Test Set")
plot(pr_rf, add = TRUE, color = "red")
legend("bottomleft",
       legend = c("Logistic Regression", "Random Forest"),
       lwd = 2, col = c("black", "red"))

print(pr_glm$auc.integral)
print(pr_rf$auc.integral)

# ---- 3. ILLUSTRATIVE COST-SENSITIVE THRESHOLD ANALYSIS -------------------
# These costs are intentionally illustrative rather than clinical estimates.
# Replace them with validated domain-specific costs before any real use.
cost_fn <- 10
cost_fp <- 1
thresholds <- seq(0.05, 0.95, by = 0.01)

expected_cost <- function(probs, y_true, t, c_fn, c_fp) {
  pred <- ifelse(probs >= t, "M", "B")
  fn <- sum(pred == "B" & y_true == "M")
  fp <- sum(pred == "M" & y_true == "B")
  fn * c_fn + fp * c_fp
}

costs_glm <- sapply(
  thresholds, expected_cost,
  probs = prob_glm, y_true = test_data$diagnosis,
  c_fn = cost_fn, c_fp = cost_fp
)

costs_rf <- sapply(
  thresholds, expected_cost,
  probs = prob_rf, y_true = test_data$diagnosis,
  c_fn = cost_fn, c_fp = cost_fp
)

best_glm_threshold <- thresholds[which.min(costs_glm)]
best_rf_threshold <- thresholds[which.min(costs_rf)]

cat("Illustrative cost-optimal GLM threshold:", best_glm_threshold, "\n")
cat("Illustrative cost-optimal RF threshold:", best_rf_threshold, "\n")

plot(thresholds, costs_glm, type = "l",
     xlab = "Classification threshold", ylab = "Expected cost",
     main = "Expected Misclassification Cost by Threshold")
lines(thresholds, costs_rf, lty = 2)
legend("topright", legend = c("Logistic Regression", "Random Forest"),
       lty = c(1, 2))

# ---- 4. SUMMARY -----------------------------------------------------------
cat("\nAdvanced analysis complete.\n")
cat("Cohen's d results:\n")
print(round(cohen_d_results, 3))
cat("\nAverage precision — Logistic Regression:", round(pr_glm$auc.integral, 3), "\n")
cat("Average precision — Random Forest:", round(pr_rf$auc.integral, 3), "\n")
cat("Illustrative 10:1 FN:FP thresholds — GLM:", best_glm_threshold,
    ", RF:", best_rf_threshold, "\n")

##############################################################################
# END OF SCRIPT
##############################################################################
